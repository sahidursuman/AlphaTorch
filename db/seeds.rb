Status.create([
    {status_code:1000 , status:'Created'                      },
    {status_code:1001 , status:'Open'                         },
    {status_code:1002 , status:'Closed'                       },
    {status_code:1003 , status:'Cancelled'                    },
    {status_code:1004 , status:'Awaiting Payment Confirmation'},
    {status_code:1005 , status:'Paid'                         },
    {status_code:1006 , status:'Final'                        },
    {status_code:1007 , status:'Not Invoiced'                 },
    {status_code:1008 , status:'Locked'                       },
    {status_code:1009 , status:'Past Due'                     },
    {status_code:1010 , status:'Error'                        },
    {status_code:1011 , status:'Active'                       },
    {status_code:1012 , status:'Inactive'                     },
])

Service.create(
    [
        {name: 'Mow Lawn',      base_cost: 10},
        {name: 'Trim Hedges',   base_cost: 15},
        {name: 'Pull Weeds',    base_cost: 10},
        {name: 'Plant Flowers', base_cost: 30},
        {name: 'Tree Removal',  base_cost: 150}
    ]
)

Country.create(
    [
        {name:'USA'}
    ]
)

State.create(
    [
        {country:Country.first, name:'Texas', short_name:'TX'},
        {country:Country.first, name:'Louisiana', short_name:'LA'}
    ]
)

Customer.create(
    [
        {first_name:'Morgan', middle_initial:'J', last_name:'Watson'},
        {first_name:'James', middle_initial:'W', last_name:'Watson'},
        {first_name:'Graham', middle_initial:'P', last_name:'Watson'}
    ]
)

Property.create(
    [
        {street_address_1:'10688 Hazelhurst Dr', street_address_2: '', city:'Houston', state:State.first, postal_code:'77043'},
        {street_address_1:'6625 Whitewing Dr',   street_address_2: '', city:'Corpus Christi', state:State.first, postal_code:'64532'},
        {street_address_1:'1214 Almond Grove',   street_address_2: '', city:'Houston', state:State.first, postal_code:'77077'},

        {street_address_1:'10683 Hazelnut Dr', street_address_2: '', city:'Houston', state:State.first, postal_code:'77041'},
        {street_address_1:'5624 Anthony St',   street_address_2: '', city:'San Antonio', state:State.first, postal_code:'64532'},
        {street_address_1:'1734 Nutmeg Ave',   street_address_2: '', city:'Houston', state:State.first, postal_code:'77074'},

        {street_address_1:'10690 Hazelhurst Dr', street_address_2: '', city:'Houston', state:State.first, postal_code:'77035'},
        {street_address_1:'66342 Western Dr',    street_address_2: '', city:'Corpus Christi', state:State.first, postal_code:'64532'},
        {street_address_1:'4324 Cherry Grove',   street_address_2: '', city:'Houston', state:State.first, postal_code:'77077'},

        {street_address_1:'10846 Duncan Dr',  street_address_2: '', city:'Houston', state:State.first, postal_code:'77143'},
        {street_address_1:'66545 Shipley Dr', street_address_2: '', city:'Corpus Christi', state:State.first, postal_code:'64732'},
        {street_address_1:'1434 Hungry Ave',  street_address_2: '', city:'Houston', state:State.first, postal_code:'77097'}
    ]
)

CustomerProperty.create(
    [
        {customer:Customer.find(2),  property:Property.first,   owner:false},
        {customer:Customer.first,    property:Property.first,   owner:true},
        {customer:Customer.find(2),  property:Property.find(2), owner:true},
        {customer:Customer.find(2),  property:Property.find(3), owner:true}
    ]

)

#Workorder.create(
#    [
#        {name:'Workorder #1', start_date:'2014-03-01', customer_property: CustomerProperty.find(2)},
#        {name:'Workorder #2', start_date:'2014-03-01', customer_property: CustomerProperty.find(2)},
#        {name:'Workorder #3', start_date:'2014-03-01', customer_property: CustomerProperty.find(3)},
#        {name:'Workorder #4', start_date:'2014-03-01', customer_property: CustomerProperty.find(4)},
#    ]
#)
#
#WorkorderService.create(
#    [
#        {service_id: 1, workorder_id: 1, schedule: {:validations=>{}, :rule_type=>'IceCube::DailyRule', :interval=>1}, cost: 10},
#        {service_id: 2, workorder_id: 1, schedule: {:validations=>{}, :rule_type=>'IceCube::DailyRule', :interval=>1}, cost: 15},
#        {service_id: 3, workorder_id: 2, schedule: {:validations=>{}, :rule_type=>'IceCube::DailyRule', :interval=>1}, cost: 150},
#        {service_id: 1, workorder_id: 3, schedule: {:validations=>{}, :rule_type=>'IceCube::DailyRule', :interval=>1}, cost: 10},
#        {service_id: 2, workorder_id: 4, schedule: {:validations=>{}, :rule_type=>'IceCube::DailyRule', :interval=>1}, cost: 10}
#    ]
#)
#Workorder.all.each(&:save)

