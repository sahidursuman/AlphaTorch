User.create!([
  {email:'admin@email.com', password:'password'}#dummy login remove for production
])

Status.create([
    {status_code:1000 , status:'Created'                      },
    {status_code:1001 , status:'Open'                         },
    {status_code:1002 , status:'Closed'                       },
    {status_code:1003 , status:'Cancelled'                    },
    {status_code:1004 , status:'Awaiting Payment Confirmation'},
    {status_code:1005 , status:'Paid'                         },
    {status_code:1006 , status:'Final'                        },
    {status_code:1007 , status:'Not Invoiced'                 },
    {status_code:1008 , status:'Invoiced'                     },
    {status_code:1009 , status:'Past Due'                     },
    {status_code:1010 , status:'Error'                        },
    {status_code:1011 , status:'Active'                       },
    {status_code:1012 , status:'Inactive'                     },
    {status_code:1013 , status:'Locked'                       },
])

Service.create(
    [
        {name: 'Mow Lawn',      base_cost: 10},
        {name: 'Trim Hedges',   base_cost: 15},
        {name: 'Pull Weeds',    base_cost: 10},
        {name: 'Plant Flowers', base_cost: 30},
        {name: 'Pruning', base_cost: 30},
        {name: 'Paving', base_cost: 40},
        {name: 'Install Irrigation System', base_cost: 150},
        {name: 'General Maintenance', base_cost: 40},
        {name: 'Mulching', base_cost: 40},
        {name: 'Sodding', base_cost: 40},
        {name: 'Gutter Cleaning', base_cost: 40},
        {name: 'Leaf Cleanup', base_cost: 40},
        {name: 'Tilling', base_cost: 40},
        {name: 'Plant Removal',  base_cost: 150}
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
        {first_name: 'Edgar ', last_name: 'Dominguez', primary_phone: '(713) 462-9693', secondary_phone: '', email: '', description: ''},
        {first_name: 'Adler Restaurant Equipment Co.', last_name: '', primary_phone: '(713) 284-0553', secondary_phone: '', email: '', description: ''},
        {first_name: 'Albert ', last_name: 'Avina',    primary_phone: '(713) 992-8733', secondary_phone: '', email: '', description: ''},
        {first_name: 'Alix', last_name: 'Nakfoor', primary_phone: '(713) 234-8939', secondary_phone: '', email: '', description: ''},
        {first_name: 'Alyson', last_name: 'Campbell', primary_phone: '(713) 650-4801', secondary_phone: '', email: '', description: ''},
        {first_name: 'Amy', last_name: 'Hartman', primary_phone: '(713) 611-1079', secondary_phone: '', email: '', description: ''},
        {first_name: 'Analee', last_name: 'Waite', primary_phone: '(713) 529-6717', secondary_phone: '', email: '', description: ''},
        {first_name: 'Andrew', last_name: 'Priest', primary_phone: '(713) 913-8511', secondary_phone: '', email: '', description: ''},
        {first_name: 'Andy', last_name: 'Friedman', primary_phone: '(713) 794-6310', secondary_phone: '', email: '', description: ''},
        {first_name: 'Ann', last_name: 'Hardiman', primary_phone: '(713) 617-3599', secondary_phone: '', email: '', description: ''},
        {first_name: 'Ashley', last_name: 'Loeffler', primary_phone: '(713) 149-9839', secondary_phone: '', email: '', description: ''},
        {first_name: 'Barry', last_name: 'Adler', primary_phone: '(713) 936-5575', secondary_phone: '', email: '', description: ''},
        {first_name: 'Bethany', last_name: 'Hughes', primary_phone: '(713) 408-0686', secondary_phone: '', email: '', description: ''},
        {first_name: 'Brian', last_name: 'Tinsley', primary_phone: '(713) 313-6999', secondary_phone: '', email: '', description: ''},
        {first_name: 'Caroline', last_name: 'Lobo', primary_phone: '(713) 905-6466', secondary_phone: '', email: '', description: ''},
        {first_name: 'Carolyn Marie', last_name: 'Markencieh', primary_phone: '(713) 216-5955', secondary_phone: '', email: '', description: ''},
        {first_name: 'Carter', last_name: 'Bechtol', primary_phone: '(713) 578-4800', secondary_phone: '', email: '', description: ''},
        {first_name: 'Charles', last_name: 'Lowrence', primary_phone: '(713) 537-9140', secondary_phone: '', email: '', description: ''},
        {first_name: 'Cheryl', last_name: 'Diamond', primary_phone: '(713) 310-7964', secondary_phone: '', email: '', description: ''},
        {first_name: 'Chris', last_name: 'Baker', primary_phone: '(713) 731-9374', secondary_phone: '', email: '', description: ''},
        {first_name: 'Cole', last_name: 'Dawson', primary_phone: '(713) 899-1102', secondary_phone: '', email: '', description: ''},
        {first_name: 'Cornelius', last_name: 'Calnan', primary_phone: '(713) 784-3051', secondary_phone: '', email: '', description: ''},
        {first_name: 'Currie', last_name: 'Bechtol', primary_phone: '(713) 497-1199', secondary_phone: '', email: '', description: ''},
        {first_name: 'Charles A.', last_name: 'Beckham Jr.', primary_phone: '(713) 468-1148', secondary_phone: '', email: '', description: ''},
        {first_name: 'George', last_name: 'Costas', primary_phone: '(713) 802-9984', secondary_phone: '', email: '', description: ''},
        {first_name: 'Cynthia', last_name: 'Anhalt', primary_phone: '(713) 538-7079', secondary_phone: '', email: '', description: ''},
        {first_name: 'Cynthia', last_name: 'Kosta', primary_phone: '(713) 576-4160', secondary_phone: '', email: '', description: ''},
        {first_name: 'Dan', last_name: 'Fleckman', primary_phone: '(713) 336-6561', secondary_phone: '', email: '', description: ''},
        {first_name: 'Edward', last_name: 'Buck', primary_phone: '(713) 996-1610', secondary_phone: '', email: '', description: ''}
    ]
)

Property.create(
    [
        {street_address_1: '42 Broad Oaks Drive', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77056'},
        {street_address_1: '710 North Post Oak', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77024'},
        {street_address_1: '2233 Pelham Drive', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77019'},
        {street_address_1: '2237 Pelham Drive', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77019'},
        {street_address_1: '3910 University Blvd', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77005'},
        {street_address_1: '6058 University Blvd', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77005'},
        {street_address_1: '6211 Holly Springs', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77057'},
        {street_address_1: '6225 Cedar Creek', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77057'},
        {street_address_1: '6249 Locke Lane', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77057'},
        {street_address_1: '10122 Chevy Chase Drive', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77056'},
        {street_address_1: '10323 Green Tree Drive', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77057'},
        {street_address_1: '12119 Murphy Road', street_address_2: '', city: 'Stafford', state:State.first, postal_code: '77477'},
        {street_address_1: '6506 Gulf Freeway', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77023'},
        {street_address_1: '1410 Lakecliff Drive', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77077'},
        {street_address_1: '6150 Longmont Drive', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77057'},
        {street_address_1: '6557 Cedar Creek', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77057'},
        {street_address_1: '6206 Willers Way', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77057'},
        {street_address_1: '2524 Stanmore Drive', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77019'},
        {street_address_1: '6224 Cedar Creek', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77057'},
        {street_address_1: '16331 Dexter Point Drive', street_address_2: '', city: 'Cypress', state:State.first, postal_code: '77411'},
        {street_address_1: '3749 Robinhood', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77005'},
        {street_address_1: '6254 Burgoyne', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77057'},
        {street_address_1: '6048 Locke Lane', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77057'},
        {street_address_1: '5105 Doliver', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77056'},
        {street_address_1: '12411 Woodthorpe Lane', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77057'},
        {street_address_1: '2218 North Blvd.', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77036'},
        {street_address_1: '909 Silver Road', street_address_2: 'Apt. 22', city: 'Houston', state:State.first, postal_code: '77024'},
        {street_address_1: '5643 Meadow Lake Lane', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77057'},
        {street_address_1: '6123 Willers Way', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77057'},
        {street_address_1: '426 West Gaywood', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77079'},
        {street_address_1: '2243 Pelham Drive', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77019'},
        {street_address_1: '3629 Piping Rock Lane', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77027'},
        {street_address_1: '2829 Amherst', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77005'},
        {street_address_1: '5917 Burgoyne Road', street_address_2: '', city: 'Houston', state:State.first, postal_code: '77057'}

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

