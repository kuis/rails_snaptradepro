# Guidelines

- Try to adhere to the following style guides as best as possible:
  - [Ruby Style Guide](https://github.com/bbatsov/ruby-style-guide)
  - [Rails Style Guide](https://github.com/bbatsov/rails-style-guide)
- Clearly document any changes or additions to the API in the README.  (VERY IMPORTANT!)
- Testing Guidelines:
  - Do not commit code to the master branch if any tests are failing.
  - Major portions of the application should have feature tests (for example, creating customers or appraisals)
  - ALL API controllers should be tested
  - Test important methods within models
  - 100% test coverage is not necessary
- Deploying:
  - There is both a Staging (`snaptradeprostaging`) and Production (`snaptradepro`) server on Heroku.
  - After you merge code into master, push to staging so Vince can review the changes.
  - After Vince has approved the changes, code can be pushed to Production.
  - Be sure to run migrations after pushing to Heroku.

# Services

To get started, you will need access to the following:

- Github
- Heroku (Staging and Production servers)
- Filepicker.io
- Trello
- Rollbar (for exception tracking)
- Codeship (for automatic test)
- HockeyApp (for beta versions of iOS app)
# Domain Model
Run `rake generate_erd` to regenerate (must have graphvis).
![](/erd.png)

# API

### GET `/api/1/appraisals`

Returns map of customers and their associated appraisals.

```ruby
{
  "Westman Bulk1"=> [
    {
      "id"=>1, 
      "number"=>nil, 
      "status"=>"Incomplete", 
      "unit"=>"A Unit", 
      "name"=>"Appraisal Named 1",
      "organization"=>{"id"=>4}
    }
  ],
  "Westman Bulk2"=> [
    {
      "id"=>4, 
      "number"=>nil, 
      "status"=>"Incomplete",
      "unit"=>"A Unit", 
      "name"=>"Appraisal Named 4",
      "organization"=>{"id"=>5}
    },
    {
      "id"=>5,
      "number"=>nil, 
      "status"=>"Incomplete", 
      "unit"=>"A Unit", 
      "name"=>"Appraisal Named 5",
      "organization"=>{"id"=>6}
    }
  ]
}
```

### GET `/api/1/organizations`

Returns organizations that a user is part of.  Includes basic customer and appraisal template info.

```ruby
[{"id"=>4,
  "name"=>"Neha Bruen Organization",
  "acronym"=>"ANA",
  "customers"=>[{"id"=>1, "account_name"=>"Westman Bulk1"}],
  "appraisal_templates"=>[{"id"=>1, "label"=>"Heavy Truck"}]
}]
```

### GET `/api/1/organizations/:org_id/appraisals/:appraisal_id`

Returns single appraisal details, organization, customer associated, and template with categories.

Add the param `complete_categories=true` to also include the full set of categories and FILLED IN fields, under a key called `categories`.

NOTE:  Categories should be ordered by weight, ascending (in the list view).

```ruby
{ "id"=>6,
  "number"=>nil,
  "status"=>"Incomplete",
  "unit"=>"A Unit",
  "name"=>"Appraisal Named 6",
  "organization"=>{
    "id"=>9, 
    "name"=>"Joyce Ondricka I Organization",
    "acronym"=>"ANA", 
    "appraisal_templates"=> [
      {"id"=>6, "name"=>"heavy_trick6", "label"=>"Heavy Truck" }
    ], 
    "customers"=>[]
  },
  "appraisal_template"=>{
    "id"=>6,
    "label"=>"Heavy Truck",
    "appraisal_categories"=>[
      {"id"=>11, "label"=>"Powertrain", "weight"=>50},
      {"id"=>12, "label"=>"Unit Identification", "weight"=>50}
    ]
  },
  "customer"=>{
    "id"=>11,
    "account_name"=>"Westman Bulk11",
    "first_name"=>"Ricky",
    "last_name"=>"Stokes",
    "email"=>nil,
    "business_phone"=>"7234123111",
    "direct_phone"=>nil,
    "street_address"=>nil,
    "city"=>nil,
    "state_or_provence"=>nil,
    "postal_code"=>nil,
    "mobile_phone"=>nil
  }
}
```

### GET `/api/1/appraisals/:appraisal_id/appraisal_categories/:category_id`

Get the fields for a particular category of an appraisal.

NOTE:  Fields weighting works similar to category weighting. 
       Fields should be ordered by weight, ascending.

```ruby
{ "id"=>2,
  "label"=>"Unit Identification",
  "weight"=>50,
  "fields"=>{
    "3"=>{
      "label"=>"ID Number",
      "field_type"=>"Text Field", 
      "value"=>"",
      "weight"=>99,
      "required"=>true
    }, 
    "4"=>{
      "label"=>"Sale Type",
      "field_type"=>"Select",
      "value"=>"",
      "choices"=>["Owner", "Dealer", "Bank"],
      "weight"=>50,
      "formatting"=>"currency-symbol: $\r\ndigits-after-decimal: 2\r\ncomma-separated: true",
      "required"=>false
    }
  }
}
```

NOTE: for select and check boxes, choices will be a newline delimited list of values.

For numeric values, formatting is a set of YAML formatted parameters describing the numeric formatting.
Numeric fields are actually always stored as floats, and should be passed around as such.

Possible numeric formatting options (may or may not be present):
```
currency-symbol: $
digits-after-decimal: 2
comma-separated: true
```

### POST `/api/1/organizations/:org_id/appraisals`

Create an appraisal. Pass in the following params:

```ruby
{ 
  appraisal: {
    appraisal_template_id (REQUIRED)
    name (REQUIRED)
    customer_id (REQUIRED)
    status
    unit
  }
}
```

#### Successful response

Returns new appraisal details

```ruby
{"response"=>
  {"id"=>6,
   "number"=>"ANA-000001",
   "status"=>nil,
   "unit"=>nil,
   "user_id"=>7,
   "customer_id"=>3,
   "appraisal_template_id"=>6,
   "organization_id"=>8,
   "created_at"=>"2014-08-04T20:11:29.757Z",
   "updated_at"=>"2014-08-04T20:11:29.760Z",
   "name"=>"an appraisal name"}}
```

#### Error response

Without customer ID specified:

```ruby
{"error"=>"invalid_resource",
 "error_description"=>"The current resource was deemed invalid.",
 "messages"=>{"customer"=>["can't be blank"]}}
```

(422 status code)


### PUT `/api/1/organizations/:org_id/appraisals/:appraisal_id`

Update an appraisal.  Any fields that are passed in from appraisal creation
can be updated, but do not need to be passed in if they are not changing.

Pass in the following params:

```ruby
{ 
  appraisal: {
    "unit" => "this is being updated",
    custom_fields: {
      "4"=>"https://www.filepicker.io/api/file/LnZooJ0Qo2E10lSYfRxu"
    }
  }
}
```

Custom fields will now raise an error if they are required and not filled in.
(Unless they have been previously filled in).  Pass in a dictionary called `custom_fields`
with they keys being the custom field ID, and the values being the desired value.

NOTE:  If you have trouble getting rails to understand PUT, just pass in
`_method: "put"` as a param.

#### Successful response

Same as appraisal creation.

#### Error response

Same as appraisal creation. (422 status code)


### POST `/api/1/organizations/:org_id/customers`

Create a customer.

```ruby
{ 
  customer: {
    account_name (REQUIRED)
    first_name (REQUIRED)
    last_name (REQUIRED)
    business_phone (REQUIRED)
    email
  }
}
```

#### Successful response

Returns new customer details

```ruby
{"response"=>
  {"id"=>1, "account_name"=>"Jim's autos"}
}
```

#### Error response

```ruby
{"error"=>"invalid_resource", 
  "error_description"=>"The current resource was deemed invalid.",
  "messages"=>{"last_name"=>["can't be blank"]}}
```

(422 status code)

### GET `/api/1/organizations/:org_id/customers/:id`

Returns organizations customer information.

```ruby
{
  "response":
    {
      "id":3,
      "account_name":"Westman Bulk3",
      "first_name":"Erika",
      "last_name":"Mueller",
      "email":null,
      "business_phone":"7234123111",
      "direct_phone":null,
      "street_address":null,
      "city":null,
      "state_or_provence":null,
      "postal_code":null,
      "mobile_phone":null
    }
}
```

### PUT `/api/1/organizations/:org_id/customers/:id`

Updates organizations customer information. You can pass in the following
params:

```ruby
{
  customer: {
      account_name
      first_name
      last_name
      email
      business_phone
      direct_phone
      street_address
      city
      state_or_provence
      postal_code
      mobile_phone
    }
}
```

#### Successful response

Returns updated customer information.

```ruby
{
  "response":
    {
      "id":3,
      "account_name":"Westman Bulk3",
      "first_name":"Erika",
      "last_name":"Mueller",
      "email":null,
      "business_phone":"7234123111",
      "direct_phone":null,
      "street_address":null,
      "city":null,
      "state_or_provence":null,
      "postal_code":null,
      "mobile_phone":null
    }
}
```

#### Error response

With field that cannot be blank.

```ruby
{"error":"invalid_resource",
  "error_description":"The current resource was deemed invalid.",
  "messages":{"business_phone":["can't be blank"]}}
```

(422 status code)



