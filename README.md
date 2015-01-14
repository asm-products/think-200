<a href="https://assembly.com/think-200/bounties"><img src="https://asm-badger.herokuapp.com/think-200/badges/tasks.svg" height="24px" alt="Open Tasks" /></a>&nbsp;&nbsp;[![Code Climate](https://codeclimate.com/github/asm-products/think-200/badges/gpa.svg)](https://codeclimate.com/github/asm-products/think-200)


## Monitor your web services with TDD

The blog post, [Test Driven Devops](http://robb.weblaws.org/2014/01/16/new-open-source-library-for-test-driven-devops/), explains it in a nutshell.

This is a product being built by the Assembly community. You can help push this idea forward by visiting [https://assembly.com/think-200](https://assembly.com/think-200).


### How Assembly Works

Assembly products are like open-source and made with contributions from the community. Assembly handles the boring stuff like hosting, support, financing, legal, etc. Once the product launches we collect the revenue and split the profits amongst the contributors.

Visit [https://assembly.com](https://assembly.com) to learn more.


### Development Setup

Vagrant-based development is set up:

1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Install [Vagrant](https://www.vagrantup.com/)
3. copy `config/database.yml-default` to `config/database.yml`
4. copy `config/secrets.yml-default` to `config/secrets.yml`
5. Run the command `vagrant up`

Vagrant will download Ubuntu, set it up, and run the rspec tests. They should all pass. The first time you do this, it may take 5–10 minutes.

The VM can be logged in to with the `vagrant ssh` command. The VM mounts the source directory at `/vagrant` in standard Vagrant style. The VM's internal port 3000 is passed through to your host machine at 3000. This all means that you can edit the source and test with a web browser on your ("host") computer, while running ruby and rspec from within the VM.

So, to run the web app in development mode:

```bash
$ vagrant ssh
$ cd /vagrant
$ bundle exec rails s
```

See the `seeds.rb` file for the initial development users and data.

### Notes

This is a sample server json response to the queue-status request:

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
