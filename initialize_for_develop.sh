#!/bin/sh

# initialize database
rake db:migrate:reset

# create meta information
rake q:register_source
rake q:register_tag
rake q:register_premise

# create questions
rake q:update_from_md
rake q:create_from_csv

# link question to information
rake q:link_q_to_src
rake q:tag_q_to_tag
rake q:tag_way
