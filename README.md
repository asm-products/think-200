### Development Setup

Install ruby 2.1.1, postgres, and redis.  Ensure postgres and redis are running.

```
git clone git@github.com:weblaws/think200.git
cd think200
bundle install
sudo ls # heat up sudo
script/initialize-dev-box
```
 

This is the server json response to the queue-status request:

```
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
