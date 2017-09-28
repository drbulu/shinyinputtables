var textTableInputBinding = new Shiny.InputBinding();

// adapted from:
// https://github.com/rstudio/shiny/blob/master/srcjs/input_binding_text.js
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
$.extend(textTableInputBinding, {
  
  find: function(scope) {
    return $(scope).find('table[class^="shinyinputtables"]');
  },
  
  initialize: function(el) {
    // unimplemented
  },
  
  getId: function(el) {
    return InputTableUtils.getParentId(el);
  },

  getValue: function(el) {
    return el.getAttribute("data-table_event");
  },
    
  setValue: function(el, value) {
    el.setAttribute("data-table_event", value);
  },
  
  subscribe: function(el, callback) {
    
    var _self = this;
    
    $(el).on('keyup.textTableInputBinding input.textTableInputBinding', 
             ".input_table_cell", function(event) {
    
      console.log("Event detected!");
      
      var evTarget = event.target;
      
      var eventVal = InputTableUtils.createEventJSON(evTarget);
      
      _self.setValue(el, eventVal);
      
      //https://stackoverflow.com/a/222824
      console.log( "New Event value: " + evTarget.value);
      console.log( "Event object: " + eventVal);
      
      callback(false);
    });
    
    $(el).on('change.textTableInputBinding', ".input_table_cell", function(event){
      callback(false);
    });
    
  },

  unsubscribe: function(el) {
    $(el).off('.textTableInputBinding');
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
      id: this.getId(el),
      data: this.getValue(el),
      tag: el.tagName
    };
  },

  // The input rate limiting policy
  getRatePolicy: function() {
    return {
      // Can be 'debounce' or 'throttle'
      policy: 'debounce',
      delay: 300
    };
  }
});

Shiny.inputBindings.register(textTableInputBinding);