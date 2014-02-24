// rails_variables.js

var url_prefix = ("#{Rails.env}" == "production") ? "/beta" : "";


console.log("url_prefix: "+url_prefix);