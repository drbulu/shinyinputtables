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

// probably move to helpers .................................

  // Finding matching class in REGEX:
  // https://stackoverflow.com/a/5424544
  containsRegex: function(a, regex){
    for(var i = 0; i < a.length; i++) {
      if(a[i].search(regex) > -1){
        return i;
      }
    }
    return -1;
  },

// ........................................................


  // This returns a jQuery object with the DOM element
  // Targets the input cells of class "input-cell" within
  // the parent table container.
  find: function(scope) {
    console.log( "find(): scope found...");
    return $(scope).find('table[class^="shinyinput"] input');
  },

  initialize: function(el){
    // TODO: Implement table element initialisation
    // once table creation strategy implemented in R code
    
    console.log( "Element initialisation: has class(es): " + el.className);
    
    // https://stackoverflow.com/a/9279379
    var baseClassREGEX = "^shinyinputtables";
    var eClasses = el.className.split(' ');
    var matchId = this.containsRegex(eClasses, baseClassREGEX);
    var targetClass = eClasses[matchId];
    
    console.log( 
      "The target class is: " + targetClass + " and is at position " + matchId + ".\n"
    );
 
    // add element id if missing!
    if (!el.hasAttribute("id")){
      // obtain the ID of el's Shiny div parent and cell ID suffix
      var parentID = this.getParentId(el);
      var idSuffix = targetClass.match("_[0-9]+-[0-9]+$").toString();
      
      // construct new id for el based on parentID and targetClass
      var elNewId = parentID + idSuffix;
      el.id = elNewId;
      el.className = el.className.replace(idSuffix, "");
      
      console.log( "This element has an ID? " + el.hasAttribute("id") + " with parent element ID: " + parentID);
      console.log( "Element now has class(es): " + el.className + " and id " + el.id + ".");
      
    } 
    
  },

  // gets the shiny div container parent of the input table
  // https://stackoverflow.com/q/10539419
  // getting element by tagName as id not always guaranteed
  getParentId: function(el){
    return $(el).parents('div[class^="shiny"]').prop("id");
  },

  getId: function(el) {
    return el.id;
  },

  getValue: function(el) {
    console.log( "getValue() on element " + el.id + " with value " + el.value + ".");
    return el.value;
  },
    
  setValue: function(el, value) {
    el.value = value;
  },
  
  subscribe: function(el, callback) {

    console.log( "Subscribing: " + el.tagName  + " with ID: " + el.id);

    $(el).on('keyup.textTableInputBinding input.textTableInputBinding', function(event) {
      
      // el.id should be equal to event.target.id
      var parentID = textTableInputBinding.getParentId(el);
      Shiny.onInputChange(parentID, el.id);
      
      console.log( "Event trigger on element: " + el.id);
      console.log( "Event element parent: " + parentID);
      
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
      delay: 300
    };
  }
});

Shiny.inputBindings.register(textTableInputBinding);