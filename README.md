### Development Setup

Create development and test users in Postgresql.
 

This is the server json response to the queue-status request:

```json
{
  "percent_complete": 80,
  "projects": {
    "1": {
      "queued": "true",
      "tested_at": 1394765771
    },
    "2": {
      "queued": "false",
      "tested_at": 1394765781
    },
    "3": {
      "queued": "false",
      "tested_at": 1394765783
    },
    "4": {
      "queued": "false",
      "tested_at": 1394765784
    },
    "5": {
      "queued": "false",
      "tested_at": 1394765785
    }
  }
} 
```
