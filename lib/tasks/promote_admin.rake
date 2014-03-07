task :promote_admin => :environment do
  Customer.first.update_attribute('admin', true)
end