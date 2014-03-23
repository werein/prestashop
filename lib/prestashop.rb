require 'prestashop/api'
require 'prestashop/client'
require 'prestashop/mapper'

# == This module is wrapper of three submodules API, Client and Mapper
# 
# === API
# Is used for comunication with Prestashop WebService
# 
# === Client
# Create instance of API, it's holded on current thread
# 
# === Mapper
# Map available Prestashop objects to class and instances.
#
# @see Api
# @see Client
# @see Mapper
# 
module Prestashop
end