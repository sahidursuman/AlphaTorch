$ ->

  popoverContent = {
    properties: {
      content:'View and edit the various properties serviced by your business.',
      title:'Properties'
    },
    customers: {
      content:'View and edit your customers.',
      title:'Customers'
    },
    workorders: {
      content:'Create, edit, and review your workorders and invoices.',
      title:'Workorders'
    }
  }

  CreatePopovers(popoverContent, {
    createLink: true
  });

