#!/bin/sh

# initialize database
rake db:migrate:reset

# create questions
rake q:create_from_md
rake q:create_from_csv

# create meta information
rake q:register_source
rake q:register_tag

# link question to information
rake q:link_q_to_src
rake q:tag_q_to_tag
