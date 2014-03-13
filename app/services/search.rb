class Search
  attr_reader :results

  def initialize(term)
    #remove periods or extra spaces made by accident
    term.gsub!(/\.|\s\s/,'')

    #term = Mor
    #@query will return MORgan
    #@a_query will return alMOnd gRove
    @query   = '%' + term + '%'
    @a_query = '%' + term.split(//).join('%') + '%'

    @results = search.map{|r| SearchResult.new(r).result}
    @results << SearchResult.new.result if @results.empty?
  end

  def search
    workorder_basic    = Workorder.select('*, 1 as Basic').where("name ILIKE ?", @query).to_sql
    workorder_advanced = Workorder.select('*, 0 as Basic').where("name ILIKE ?", @a_query).to_sql

    service_basic    = Service.select('*, 1 as Basic').where("name ILIKE ?", @query).to_sql
    service_advanced = Service.select('*, 0 as Basic').where("name ILIKE ?", @a_query).to_sql

    customer_basic    = Customer.select('*, 1 as Basic').where("first_name || ' ' || middle_initial || ' ' || last_name ILIKE ?", @query).to_sql
    customer_advanced = Customer.select('*, 0 as Basic').where("first_name || ' ' || middle_initial || ' ' || last_name ILIKE ?", @a_query).to_sql

    #manually use columns because the id column in property and state will conflict and cause an
    #ambiguous column error in postgres.
    prop_cols         = 'properties.id, street_address_1, street_address_2, city, postal_code'
    property_basic    = Property.select("#{prop_cols}, 1 as Basic").joins(:state).where("street_address_1 ILIKE ? OR street_address_2 ILIKE ? OR city ILIKE ? OR states.name ILIKE ? OR postal_code ILIKE ?", @query,@query,@query,@query,@query).to_sql
    property_advanced = Property.select("#{prop_cols}, 0 as Basic").joins(:state).where("street_address_1 ILIKE ? OR street_address_2 ILIKE ? OR city ILIKE ? OR states.name ILIKE ? OR postal_code ILIKE ?", @a_query,@a_query,@a_query,@a_query,@a_query,).to_sql

    workorder = query(Workorder, workorder_basic, workorder_advanced)
    service = query(Service, service_basic, service_advanced)
    customer = query(Customer, customer_basic, customer_advanced)
    property = query(Property, property_basic, property_advanced)

    customer + property + workorder + service

  end

  def query(klass, basic, advanced)
    #property query joins state and the id columns will conflict
    prefix = klass.to_s == 'Property' ? 'properties.' : nil
    sql = "WITH
            basic    AS (#{basic}),
            advanced AS (#{advanced} AND #{prefix}id NOT IN(SELECT #{prefix}id FROM basic))

           SELECT * FROM basic
           UNION
           SELECT * FROM advanced
           ORDER BY Basic DESC
           LIMIT(25);
          "
    klass.find_by_sql(sql)
  end

end


class SearchResult
  attr_reader :result

  def initialize(object=nil)
    if object
      klass = (object.class.to_s + 'SearchResult').constantize
      @result = klass.new(object).result
    else
      @result = {
          value:    '',
          icon:     'icon-remove',
          category: 'No Results...',
          url:      '#'
      }
    end
  end
end


class WorkorderSearchResult < SearchResult
  def initialize(workorder)
    @result = {
        value:     workorder.name,
        id:        workorder.id,
        icon:     'icon-book',
        category: 'Workorders',
        url:      "workorders/#{workorder.id}"
    }
  end
end

class ServiceSearchResult < SearchResult
  def initialize(service)
    @result = {
        value:     service.name,
        id:        service.id,
        cost:      service.base_cost,
        icon:     'icon-wrench',
        category: 'Services',
        url:       "services/#{service.id}"
    }
  end
end

class CustomerSearchResult < SearchResult
  def initialize(customer)
    @result = {
        value:     customer.name,
        id:        customer.id,
        icon:     'icon-user',
        category: 'Customers',
        url:       "customers/#{customer.id}"
    }
  end
end

class PropertySearchResult < SearchResult
  def initialize(property)
    @result = {
        value:     property.street_address_1,
        id:        property.id,
        icon:     'icon-home',
        category: 'Properties',
        url:       "properties/#{property.id}"
    }
  end
end