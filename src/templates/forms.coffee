tc = require 'teacup'

{ capitalize } = require '../apputil'


########################################
# Form Templates
########################################
form_group_input_div = tc.renderable (data) ->
  tc.div '.form-group', ->
    tc.label '.control-label',
      for:data.input_id
      data.label
    selector = "##{data.input_id}.form-control"
    atts = data.input_attributes 
    input_type = tc.input
    if data?.input_type
      input_type = tc[data.input_type]
      input_type selector, atts, ->
        tc.text data?.content
    else
      input_type selector, atts

make_field_input = (field) ->
  tc.renderable (model) ->
    form_group_input_div
      input_id: "input_#{field}"
      label: capitalize field
      input_attributes:
        name: field
        placeholder: field
        value: model[field]
    
make_field_textarea = (field) ->
  tc.renderable (model) ->
    form_group_input_div
      input_id: "input_#{field}"
      input_type: 'textarea'
      label: capitalize field
      input_attributes:
        name: field
        placeholder: field
      content: model[field]

make_field_select = (field, optlist) ->
  tc.renderable (model) ->
    tc.div '.form-group', ->
      tc.label '.control-label',
        for:"select_#{field}"
      capitalize field
    tc.select '.form-control', name:"select_#{field}", ->
      for opt in optlist
        if model[field] is opt
          tc.option selected:null, value:opt, opt
        else
          tc.option value:opt, opt
          
make_login_form = (action='/login', method='POST') -> 
  tc.renderable (user) ->
    tc.form
      role:'form'
      method: method
      action: action, ->
        form_group_input_div
          input_id: 'input_username'
          label: 'User Name'
          input_attributes:
            name: 'username'
            placeholder: 'User Name'
        form_group_input_div
          input_id: 'input_password'
          label: 'Password'
          input_attributes:
            name: 'password'
            type: 'password'
            placeholder: 'Type your password here....'
        tc.button '.btn.btn-default', type:'submit', 'login'

login_form = make_login_form()

name_content_form = tc.renderable (model) ->
  form_group_input_div
    input_id: 'input_name'
    label: 'Name'
    input_attributes:
      name: 'name'
      placeholder: 'Name'
  form_group_input_div
    input_id: 'input_content'
    input_type: tc.textarea
    label: 'Content'
    input_attributes:
      name: 'content'
      placeholder: '...'
  tc.input '.btn.btn-default.btn-xs', type:'submit', value:'Add'

########################################
module.exports =
  form_group_input_div: form_group_input_div
  make_field_input: make_field_input
  make_field_textarea: make_field_textarea
  make_field_select: make_field_select
  make_login_form: make_login_form
  login_form: login_form
  name_content_form: name_content_form
