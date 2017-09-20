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

  // This returns a jQuery object with the DOM element
  // Targets the input cells of class "input-cell" within
  // the parent table container.
  find: function(scope) {
    return $(scope).find('.input-cell');
  },


//  initialize: function(el){
    // TODO: Implement table element initialisation
    // once table creation strategy implemented in R code
//  },

  // gets the shiny div container parent of the input table
  getParentId: function(el){
    console.log( "getParentId() on element " + el.id + "...");
    return $(el).parents('div[class^="shiny"]').prop("id");
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
  
  subscribe: function(el, callback) {

    $(el).on('keyup.textTableInputBinding input.textTableInputBinding', function(event) {
      
      console.log( "Event trigger on element: " + el.id);
      
      var parentID = textTableInputBinding.getParentId(el);
      
      Shiny.onInputChange(parentID, el.id);
      callback(true);
    });
    
    $(el).on('change.textTableInputBinding', function(event) {
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

Shiny.inputBindings.register(textTableInputBinding);