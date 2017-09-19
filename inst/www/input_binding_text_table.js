var editTableInputBinding = new Shiny.InputBinding();

// adapted from:
// https://shiny.rstudio.com/gallery/custom-input-bindings.html
// https://www.w3schools.com/tags/att_input_readonly.asp
// https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input#Attributes
// https://stackoverflow.com/questions/3676127/how-do-i-make-a-text-input-non-editable
// https://api.jquery.com/removeAttr/
// https://stackoverflow.com/questions/5995628/adding-attribute-in-jquery
// https://stackoverflow.com/questions/2496443/how-i-can-add-and-remove-the-attribute-readonly
// avoids memory leaks?: https://api.jquery.com/data/ (recommended in the prop vs attr discussion)
// 

// An input binding must implement these methods
// https://github.com/rstudio/shiny/blob/master/srcjs/input_binding_text.js
$.extend(editTableInputBinding, {

  // This returns a jQuery object with the DOM element
  // Targets the input cells of class "input-cell" within
  // the parent table container.
  find: function(scope) {
    //return $(scope).find('.editable_input_table .input-cell');
    return $(scope).find('.input-cell');
  },

  getId: function(el) {
    return el.id;
  },

  getValue: function(el) {
    console.log( "getValue() on element " + el.id + "...");
    return el.value;
  },
    
  setValue: function(el, value) {
    el.value = value;
  },

    // Set up the event listeners so that interactions with the
    // input will result in data being sent to server.
    // callback is a function that queues data to be sent to
    // the server.
          
    // 1. get shiny parent entity's ID : 
    // this is the triggered event's main context to alert the table user.
    // you could cheat and append a hardcoded prefix to avoid depending on div as shiny parent.
        
    // 2. Trigger new shiny input change event based on changed input element ('el')
    // new event ID: ID of the Shiny parent container of 'el' (e.g. div)
    // new event value: the ID of 'el', which triggered the source event
  subscribe: function(el, callback) {

    $(el).on('keyup.editTableInputBinding input.editTableInputBinding', function(event) {
      
      console.log( "Event trigger on element: " + el.id);
      
      var parentID = $(el).parents('div[class^="shiny"]').prop("id");
      Shiny.onInputChange(parentID, el.id);
      callback(true);
    });
    
    $(el).on('change.editTableInputBinding', function(event) {
      callback(false);
    });
    
  },

  unsubscribe: function(el) {
    $(el).off('.editTableInputBinding');
  },

  receiveMessage: function(el, data) {
    
    if (data.hasOwnProperty('value'))
      this.setValue(el, data.value);
    
    if (data.hasOwnProperty('label'))
      $(el).parent().find('label[for="' + $escape(el.id) + '"]').text(data.label);

    if (data.hasOwnProperty('placeholder'))
      el.placeholder = data.placeholder;

    $(el).trigger('change');
    
  },
  
  getState: function(el) {
    return {
      label: $(el).parent().find('label[for="' + $escape(el.id) + '"]').text(),
      value: el.value,
      placeholder: el.placeholder
    };
  },

  // The input rate limiting policy
  getRatePolicy: function() {
    return {
      // Can be 'debounce' or 'throttle'
      policy: 'debounce',
      delay: 250
    };
  }
});

Shiny.inputBindings.register(editTableInputBinding);