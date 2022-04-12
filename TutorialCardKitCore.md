# CardCitCore Tutorial

## CardKitCore API 

```ts
type CKCCardParams = {
  pan: string               // card number (without separators and spaces)
  cvc: string
  expiryMMYY: string        // date in MM/YYY or MMYYY format
  cardholder: string | null // if null - not validated
  mdOrder: string
  pubKey: string
  seTokenTimestamp: string | null // if null - the sdk gets a smartphone local time
}

type CKCBindingParams = {
  bindingID: string
  cvc: string | null // if null, then it is not validated
  mdOrder: string
  pubKey: string
  seTokenTimestamp: string | null // if null - the sdk gets in a smartphone local time
}

type CKCError = 
   | 'invalid-pub-key' // empty or invalid key
   | 'required'        // Required field
   | 'invalid-format'  // invalid data format (for example, numbers in a cardholder)
   | 'invalid-length'  // invalid field length
   | 'invalid'         // invalid field value (general)
   
type CKCField = 
   | 'pan'
   | 'cvc'
   | 'expiryMMYY'
   | 'cardholder'
   | 'bindingID'
   | 'mdOrder'
   | 'pubKey'

type CKCTokenResult = {
  token: string | null
  errors: [{field: CKCField, error: CKCError }] | null
}

class CKCPubKey {
  // utility for parsing JSON response from public key servers
  static fromJSONString(json: string): string | null
}

class CKCToken {
  static generateWithBinding(params: CKCBindingParams): CKCTokenResult
  static generateWithCard(params: CKCCardParams): CKCTokenResult
  static timestampForDate(NSDate: date): string
}

```

Example of use

```ts

let result = CKCToken.generateWithCard(
  {
    pan: "123",
    cvc: "",
    expiryMMYY: "12/25",
    mdOrder: "md-order-value",
    pubKey: "[pub-key-value]"
  }
)

console.log(result)

{
  token: null,
  errors: [
    {field: "pan", error: "invalid-length"},
    {field: "cvc", error: "required"}
  ]
}

```

## Implementation example

### Token generation by card data
```swift
import CardKitCore

let cardParams = CKCCardParams()
cardParams.cardholder= "Korotkov Alex"
cardParams.expiryMMYY= "1222" // or 12/22
cardParams.pan= "5536913776755304"
cardParams.cvc =  "123"
cardParams.mdOrder =  "mdorder"
cardParams.pubKey =  "-----BEGIN PUBLIC KEY-----MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoIITqh9xlGx4tWA+aucb0V0YuFC9aXzJb0epdioSkq3qzNdRSZIxe/dHqcbMN2SyhzvN6MRVl3xyjGAV+lwk8poD4BRW3VwPUkT8xG/P/YLzi5N8lY6ILlfw6WCtRPK5bKGGnERcX5dqL60LhOPRDSYT5NHbbp/J2eFWyLigdU9Sq7jvz9ixOLh6xD7pgNgHtnOJ3Cw0Gqy03r3+m3+CBZwrzcp7ZFs41bit7/t1nIqgx78BCTPugap88Gs+8ZjdfDvuDM+/3EwwK0UVTj0SQOv0E5KcEHENL9QQg3ujmEi+zAavulPqXH5907q21lwQeemzkTJH4o2RCCVeYO+YrQIDAQAB-----END PUBLIC KEY-----"

let res = CKCToken.generate(withCard: cardParams);
```

### Token generation by BindingId

```swift
import CardKitCore

let bindingParams = CKCBindingParams()
bindingParams.bindingID = "das"
bindingParams.cvc = "123"
bindingParams.mdOrder = "mdOrder"
bindingParams.pubKey = "-----BEGIN PUBLIC KEY-----MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoIITqh9xlGx4tWA+aucb0V0YuFC9aXzJb0epdioSkq3qzNdRSZIxe/dHqcbMN2SyhzvN6MRVl3xyjGAV+lwk8poD4BRW3VwPUkT8xG/P/YLzi5N8lY6ILlfw6WCtRPK5bKGGnERcX5dqL60LhOPRDSYT5NHbbp/J2eFWyLigdU9Sq7jvz9ixOLh6xD7pgNgHtnOJ3Cw0Gqy03r3+m3+CBZwrzcp7ZFs41bit7/t1nIqgx78BCTPugap88Gs+8ZjdfDvuDM+/3EwwK0UVTj0SQOv0E5KcEHENL9QQg3ujmEi+zAavulPqXH5907q21lwQeemzkTJH4o2RCCVeYO+YrQIDAQAB-----END PUBLIC KEY-----"

let res = CKCToken.generate(withBinding: bindingParams)
```

### Extracting public key from JSON

```swift
let JSONWithPubKey = """{
  "keys":[{
    "keyValue":"-----BEGIN PUBLIC KEY-----MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAhjH8R0jfvvEJwAHRhJi2Q4fLi1p2z10PaDMIhHbD3fp4OqypWaE7p6n6EHig9qnwC/4U7hCiOCqY6uYtgEoDHfbNA87/X0jV8UI522WjQH7Rgkmgk35r75G5m4cYeF6OvCHmAJ9ltaFsLBdr+pK6vKz/3AzwAc/5a6QcO/vR3PHnhE/qU2FOU3Vd8OYN2qcw4TFvitXY2H6YdTNF4YmlFtj4CqQoPL1u/uI0UpsG3/epWMOk44FBlXoZ7KNmJU29xbuiNEm1SWRJS2URMcUxAdUfhzQ2+Z4F0eSo2/cxwlkNA+gZcXnLbEWIfYYvASKpdXBIzgncMBro424z/KUr3QIDAQAB-----END PUBLIC KEY-----",
    "protocolVersion":"RSA",
    "keyExpiration":1661599747000
    }
  ]}""";

CKCPubKey.fromJSONString(JSONWithPubKey); // Return "-----BEGIN PUBLIC KEY-----MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAhjH8R0jfvvEJwAHRhJi2Q4fLi1p2z10PaDMIhHbD3fp4OqypWaE7p6n6EHig9qnwC/4U7hCiOCqY6uYtgEoDHfbNA87/X0jV8UI522WjQH7Rgkmgk35r75G5m4cYeF6OvCHmAJ9ltaFsLBdr+pK6vKz/3AzwAc/5a6QcO/vR3PHnhE/qU2FOU3Vd8OYN2qcw4TFvitXY2H6YdTNF4YmlFtj4CqQoPL1u/uI0UpsG3/epWMOk44FBlXoZ7KNmJU29xbuiNEm1SWRJS2URMcUxAdUfhzQ2+Z4F0eSo2/cxwlkNA+gZcXnLbEWIfYYvASKpdXBIzgncMBro424z/KUr3QIDAQAB-----END PUBLIC KEY-----"
```