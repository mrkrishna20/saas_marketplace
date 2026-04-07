# SaaS Marketplace - Design Note

## Overview

This document outlines the architecture and key design decisions for the SaaS Marketplace application. The platform enables companies to offer products/services to clients who can browse and place orders across multiple companies.

## System Architecture

### Core Entities

**Users & Companies**
- Company belong to exactly one user
- Company admins can manage products and view orders
- Users authenticate via JWT tokens

**Clients**
- Can register, login, and interact with multiple companies
- Authenticate via separate JWT tokens with client_id
- Can be associated with companies or exist independently
- Can buy products from any company

**Products**
- Belong to specific companies
- Visible globally to all clients
- Have name and price attributes

**Orders**
- Created by clients for specific products
- Link clients to companies through products
- Minimal state: pending, cancelled, completed

**Company Clients**
- Optional association between companies and existing clients
- Support dummy email generation

### Authentication Strategy

**Dual Authentication System**
- Users: JWT with user_id payload
- Clients: JWT with client_id payload
- Shared authentication method in ApplicationController
- Role-based access control throughout the system

## Key Design Decisions

### 1. Multi-Company Client Interaction
Clients can interact with any company without being tied to a specific one. This creates a true marketplace where clients have freedom to browse and order from any participating company.

### 2. Decoupled Client-Company Relationships
Company clients can exist independently (null client_id) or be associated with existing global clients. This flexibility supports various business models:
- Standalone company-specific clients
- Global clients with company-specific relationships

### 3. Simplified Order Management
Orders follow a create-only pattern with minimal state management., ensuring data integrity and audit trails.

### 4. Product-Centric Marketplace
Products are the bridge between companies and clients. All products are globally visible, enabling discovery across the entire marketplace.

### 5. Phone Number Validation
Strict 10-digit numerical format ensures data consistency across the platform while keeping phone numbers optional.

## API Design Philosophy

### RESTful with Constraints
- Standard HTTP methods and status codes
- Consistent JSON response format
- Minimal CRUD operations (orders are create-only)
- Clear separation between user and client endpoints

### Error Handling
- Standardized error responses
- Appropriate HTTP status codes
- Validation errors with detailed messages
- Authentication/authorization errors clearly separated

### Data Privacy
- Dummy emails for company clients without real emails
- Sensitive data filtering in JSON responses
- Optional contact information (email/phone)

## Security Considerations

### JWT Token Management
- Stateless authentication
- Separate token spaces for users and clients
- No server-side token storage required
- Client-side token responsibility for logout

### Authorization Layers
- Company-level access control
- Admin-only operations (product creation)
- Client-only operations (order creation)
- Resource ownership verification

### Data Validation
- Phone number format enforcement
- Email format validation
- Required field presence checks
- Uniqueness constraints

## Scalability Considerations

### Database Design
- Normalized relationships
- Foreign key constraints
- Index-friendly ID fields
- Minimal data duplication

### API Performance
- Eager loading for related data
- Efficient query patterns
- Pagination-ready structure
- Minimal response payloads

## Future Extensibility

### Payment Integration
- Order amount field ready for payment processing
- Company-specific payment methods
- Transaction history tracking

### Advanced Features
- Product categories and search
- Client reviews and ratings
- Company profiles and verification
- Order status workflows
- Notification systems

### Analytics
- Order metrics per company
- Client behavior tracking
- Product performance analytics
- Revenue reporting

## Conclusion

The SaaS Marketplace architecture prioritizes flexibility, security, and simplicity. The dual authentication system supports both B2B and B2C interactions, while the product-centric approach enables true marketplace functionality. The design balances feature completeness with maintainability, providing a solid foundation for future enhancements.

---

## API Endpoints

### Authentication
- `POST /api/v1/users/signup` - User registration
- `POST /api/v1/sessions/login` - User login
- `POST /api/v1/sessions/logout` - User logout
- `POST /api/v1/clients/register` - Client registration
- `POST /api/v1/clients/login` - Client login

### Company Management
- `POST /api/v1/companies` - Create company

### Products
- `GET /api/v1/products` - List all products (global)
- `POST /api/v1/products` - Create product (admin only)

### Company Clients
- `GET /api/v1/company_clients` - List company clients
- `POST /api/v1/company_clients` - Create company client

### Orders
- `GET /api/v1/orders` - List orders (user/client specific)
- `POST /api/v1/orders` - Create order (clients only)

### Client Features
- `GET /api/v1/clients/companies` - List client's companies