admin = User.new(email:'admin@cl.com', password:'password', admin_confirmed:true)
admin.skip_confirmation!
admin.save!

(1..10).each do |i|
  user = User.new(email:"guest#{i}@cl.com", password:'password')
  user.skip_confirmation!
  user.save!
end

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
        {name: 'Mow Lawn',      base_cost_dollars: 9.99},
        {name: 'Trim Hedges',   base_cost_dollars: 14.99},
        {name: 'Pull Weeds',    base_cost_dollars: 9.99},
        {name: 'Plant Flowers', base_cost_dollars: 29.99},
        {name: 'Pruning', base_cost_dollars: 29.99},
        {name: 'Paving', base_cost_dollars: 39.99},
        {name: 'Install Irrigation System', base_cost_dollars: 149.99},
        {name: 'General Maintenance', base_cost_dollars: 39.99},
        {name: 'Mulching', base_cost_dollars: 39.99},
        {name: 'Sodding', base_cost_dollars: 39.99},
        {name: 'Gutter Cleaning', base_cost_dollars: 39.99},
        {name: 'Leaf Cleanup', base_cost_dollars: 39.99},
        {name: 'Tilling', base_cost_dollars: 39.99},
        {name: 'Plant Removal',  base_cost_dollars: 149.99}
    ]
)

[
    "Afghanistan",
    "Aland Islands",
    "Albania",
    "Algeria",
    "American Samoa",
    "Andorra",
    "Angola",
    "Anguilla",
    "Antarctica",
    "Antigua And Barbuda",
    "Argentina",
    "Armenia",
    "Aruba",
    "Australia",
    "Austria",
    "Azerbaijan",
    "Bahamas",
    "Bahrain",
    "Bangladesh",
    "Barbados",
    "Belarus",
    "Belgium",
    "Belize",
    "Benin",
    "Bermuda",
    "Bhutan",
    "Bolivia",
    "Bosnia and Herzegowina",
    "Botswana",
    "Bouvet Island",
    "Brazil",
    "British Indian Ocean Territory",
    "Brunei Darussalam",
    "Bulgaria",
    "Burkina Faso",
    "Burundi",
    "Cambodia",
    "Cameroon",
    "Canada",
    "Cape Verde",
    "Cayman Islands",
    "Central African Republic",
    "Chad",
    "Chile",
    "China",
    "Christmas Island",
    "Cocos (Keeling) Islands",
    "Colombia",
    "Comoros",
    "Congo",
    "Congo, the Democratic Republic of the",
    "Cook Islands",
    "Costa Rica",
    "Cote d'Ivoire",
    "Croatia",
    "Cuba",
    "Cyprus",
    "Czech Republic",
    "Denmark",
    "Djibouti",
    "Dominica",
    "Dominican Republic",
    "Ecuador",
    "Egypt",
    "El Salvador",
    "Equatorial Guinea",
    "Eritrea",
    "Estonia",
    "Ethiopia",
    "Falkland Islands (Malvinas)",
    "Faroe Islands",
    "Fiji",
    "Finland",
    "France",
    "French Guiana",
    "French Polynesia",
    "French Southern Territories",
    "Gabon",
    "Gambia",
    "Georgia",
    "Germany",
    "Ghana",
    "Gibraltar",
    "Greece",
    "Greenland",
    "Grenada",
    "Guadeloupe",
    "Guam",
    "Guatemala",
    "Guernsey",
    "Guinea",
    "Guinea-Bissau",
    "Guyana",
    "Haiti",
    "Heard and McDonald Islands",
    "Holy See (Vatican City State)",
    "Honduras",
    "Hong Kong",
    "Hungary",
    "Iceland",
    "India",
    "Indonesia",
    "Iran, Islamic Republic of",
    "Iraq",
    "Ireland",
    "Isle of Man",
    "Israel",
    "Italy",
    "Jamaica",
    "Japan",
    "Jersey",
    "Jordan",
    "Kazakhstan",
    "Kenya",
    "Kiribati",
    "Korea, Democratic People's Republic of",
    "Korea, Republic of",
    "Kuwait",
    "Kyrgyzstan",
    "Lao People's Democratic Republic",
    "Latvia",
    "Lebanon",
    "Lesotho",
    "Liberia",
    "Libyan Arab Jamahiriya",
    "Liechtenstein",
    "Lithuania",
    "Luxembourg",
    "Macao",
    "Macedonia, The Former Yugoslav Republic Of",
    "Madagascar",
    "Malawi",
    "Malaysia",
    "Maldives",
    "Mali",
    "Malta",
    "Marshall Islands",
    "Martinique",
    "Mauritania",
    "Mauritius",
    "Mayotte",
    "Mexico",
    "Micronesia, Federated States of",
    "Moldova, Republic of",
    "Monaco",
    "Mongolia",
    "Montenegro",
    "Montserrat",
    "Morocco",
    "Mozambique",
    "Myanmar",
    "Namibia",
    "Nauru",
    "Nepal",
    "Netherlands",
    "Netherlands Antilles",
    "New Caledonia",
    "New Zealand",
    "Nicaragua",
    "Niger",
    "Nigeria",
    "Niue",
    "Norfolk Island",
    "Northern Mariana Islands",
    "Norway",
    "Oman",
    "Pakistan",
    "Palau",
    "Palestinian Territory, Occupied",
    "Panama",
    "Papua New Guinea",
    "Paraguay",
    "Peru",
    "Philippines",
    "Pitcairn",
    "Poland",
    "Portugal",
    "Puerto Rico",
    "Qatar",
    "Reunion",
    "Romania",
    "Russian Federation",
    "Rwanda",
    "Saint Barthelemy",
    "Saint Helena",
    "Saint Kitts and Nevis",
    "Saint Lucia",
    "Saint Pierre and Miquelon",
    "Saint Vincent and the Grenadines",
    "Samoa",
    "San Marino",
    "Sao Tome and Principe",
    "Saudi Arabia",
    "Senegal",
    "Serbia",
    "Seychelles",
    "Sierra Leone",
    "Singapore",
    "Slovakia",
    "Slovenia",
    "Solomon Islands",
    "Somalia",
    "South Africa",
    "South Georgia and the South Sandwich Islands",
    "Spain",
    "Sri Lanka",
    "Sudan",
    "Suriname",
    "Svalbard and Jan Mayen",
    "Swaziland",
    "Sweden",
    "Switzerland",
    "Syrian Arab Republic",
    "Taiwan, Province of China",
    "Tajikistan",
    "Tanzania, United Republic of",
    "Thailand",
    "Timor-Leste",
    "Togo",
    "Tokelau",
    "Tonga",
    "Trinidad and Tobago",
    "Tunisia",
    "Turkey",
    "Turkmenistan",
    "Turks and Caicos Islands",
    "Tuvalu",
    "Uganda",
    "Ukraine",
    "United Arab Emirates",
    "United Kingdom",
    "United States",
    "United States Minor Outlying Islands",
    "Uruguay",
    "Uzbekistan",
    "Vanuatu",
    "Venezuela",
    "Viet Nam",
    "Virgin Islands, British",
    "Virgin Islands, U.S.",
    "Wallis and Futuna",
    "Western Sahara",
    "Yemen",
    "Zambia",
    "Zimbabwe"
].each do |country|
  Country.create(name:country)
end

State.create(
    [
        {country:Country.find_by_name('United States'), name:'Texas', short_name:'TX'},
        {country:Country.find_by_name('United States'), name:'Louisiana', short_name:'LA'}
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

Landscaper.create(
    [
        {first_name: 'Thomas', last_name: 'Aguilar', primary_phone: '(713) 438-1839', secondary_phone: '', email: 'taguilar@yahoo.com', rating: ''},
        {first_name: 'Marcelino', last_name: 'Cortez', primary_phone: '(713) 238-1831', secondary_phone: '', email: 'mcortez@gmail.com', rating: ''},
        {first_name: 'Carlos', last_name: 'Guiteraz', primary_phone: '(281) 283-1342', secondary_phone: '', email: 'cguitee@gmail.com', rating: ''},
        {first_name: 'Mark', last_name: 'Acosta', primary_phone: '(713) 823-1824', secondary_phone: '', email: 'macsta332@yahoo.com', rating: ''},
        {first_name: 'Sam', last_name: 'Read', primary_phone: '(832) 293-2912', secondary_phone: '', email: 'sammyready@gmail.com', rating: ''},
        {first_name: 'Ramon ', last_name: 'Costello', primary_phone: '(713) 822-1333', secondary_phone: '', email: 'rcostello090933@yahoo.com', rating: ''}
    ]
)
