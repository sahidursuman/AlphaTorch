$ ->

  popoverContent = {
    properties: {
      content:'Look at information about the various properties serviced by your business.',
      title:'Properties'
    },
    people: {
      content:'View customer and employee data all in one location.',
      title:'People'
    },
    workorders: {
      content:'Create, edit, and review your workorders and invoices.',
      title:'Workorders'
    }
  }

  CreatePopovers(popoverContent, {
    createLink: true
  });

