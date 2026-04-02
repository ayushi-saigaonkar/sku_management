# Order Intake & SKU Stats System

This is a Rails API application that handles sku management.

---

Setup
bundle install
rails db:create db:migrate
rails server

Models
Order
external_id (unique)
placed_at
locked_at

LineItem
sku
quantity
original (used for versioning corrections)

SkuStat
sku
week
total_quantity
API Endpoints
Create Order

POST /orders

Example:

{
  "external_id": "SAP-ORDER-1234",
  "placed_at": "2025-04-17T12:00:00Z",
  "line_items": [
    { "sku": "SKU123", "quantity": 10 },
    { "sku": "SKU456", "quantity": 5 }
  ]
}
Lock Order

POST /orders/:id/lock

Locks the order permanently and prevents further updates.

SKU Stats

GET /sku_stats?sku=SKU123

Returns precomputed SKU statistics with optional pagination.
 
 
Idempotency

Orders are uniquely identified using external_id.

If the same order is received again:

Existing line items are marked as original: false
New line items are created as the latest version

This ensures safe correction handling without mutating past data.

Order Correction Rules
Orders can be updated within 15 minutes of creation
Orders cannot be modified if:
They are locked
They are older than 15 minutes


Background Processing
SKU stats are calculated asynchronously using ActiveJob.
Triggered after order creation/update/lock
Uses latest original: true line items
Aggregates quantity using database .sum


