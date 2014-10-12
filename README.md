README
======

The goal of the project is to provide web-interface to contribute to semi-static projects like http://aula.io & http://microrb.com/




List of projects
================
- http://aula.io
- http://microrb.com
- https://github.com/trek/beautiful-open
- https://github.com/percolator-io/categories
- https://github.com/strzalek/queues.io
- https://github.com/ruby-conferences/ruby-conferences-site
- https://github.com/awagener/iwanttolearnruby
- this project itself (for adding more projects) - once deployed


Architecture
============

Four main parts for now:

1. Generate data in required format
2. Commit, push & submit pull request
3. Generate & draw form
4. Authentication


Run
===

# Forms:
ruby app.rb
shotgun app.rb -p 4567
bundle exec rackup -p9393

# Work with github API:
ruby git-test.rb

Ansible
=========
ansible-playbook root-setup.yml -u root
ansible-playbook setup.yml -u appwww
