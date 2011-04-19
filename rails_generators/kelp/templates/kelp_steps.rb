# kelp_steps.rb
#
# This file defines some generic step definitions that utilize the helper
# methods provided by Kelp. It is auto-generated by running:
#
#   script/generate kelp
#
# from a Rails application. It's probably a good idea to avoid editing this
# file, since it may be overwritten by an upgraded kelp gem later. If you
# find an issues with these step definitions and think they can be improved,
# please create an issue on Github:
#
#   http://github.com/wapcaplet/kelp/issues
#

require 'kelp'
World(Kelp::Attribute)
World(Kelp::Checkbox)
World(Kelp::Dropdown)
World(Kelp::Field)
World(Kelp::Navigation)
World(Kelp::Scoping)
World(Kelp::Visibility)

module KelpStepHelper
  # Convert a Cucumber::Ast::Table or multiline string into
  # a list of strings
  def listify(items)
    if items.class == Cucumber::Ast::Table
      strings = items.raw.flatten
    else
      strings = items.split(/[\r\n]+/)
    end
  end
end
World(KelpStepHelper)

SHOULD_OR_NOT = /(should|should not)/
WITHIN = /(?: within "([^\"]+)")?/
ELEMENT = /(?:field|checkbox|dropdown|button)/
STR = /([^\"]+)/

# Verify the presence or absence of multiple text strings in the page,
# or within a given context.
#
# With `should see`, fails if any of the strings are missing.
# With `should not see`, fails if any of the strings are present.
#
# `items` may be a Cucumber table, or a multi-line string. Examples:
#
#   Then I should see the following:
#     | Apple crumble    |
#     | Banana cream pie |
#     | Cherry tart      |
#
#   Then I should see the following:
#     """
#     Bacon & Eggs
#     Biscuits & Gravy
#     Hash Browns
#     """
#
Then /^I #{SHOULD_OR_NOT} see the following#{WITHIN}:$/ do |expect, selector, items|
  strings = listify(items)
  if expect == 'should'
    should_see strings, :within => selector
  else
    should_not_see strings, :within => selector
  end
end


# Verify that one or more table rows containing the correct values exist (or do
# not exist). Rows do not need to match exactly, and fields do not need to be
# in the same order.
#
# Examples:
#
#   Then I should see table rows containing:
#     | Eric | Edit |
#     | John | Edit |
#   And I should not see a table row containing:
#     | Eric | Delete |
#
Then /^I #{SHOULD_OR_NOT} see (?:a table row|table rows)#{WITHIN} containing:$/ do |expect, selector, rows|
  rows.raw.each do |fields|
    if expect == 'should'
      should_see_in_same_row(fields, :within => selector)
    else
      should_not_see_in_same_row(fields, :within => selector)
    end
  end
end


# Verify that a dropdown has a given value selected. This verifies the visible
# value shown to the user, rather than the value attribute of the selected
# option element.
#
# Examples:
#
#   Then the "Height" dropdown should equal "Average"
#
Then /^the "#{STR}" dropdown#{WITHIN} should equal "#{STR}"$/ do |dropdown, selector, value|
  dropdown_should_equal(dropdown, value, :within => selector)
end


# Verify that a dropdown includes or doesn't include the given value.
#
# Examples:
#
#   Then the "Height" dropdown should include "Tall"
#
Then /^the "#{STR}" dropdown#{WITHIN} #{SHOULD_OR_NOT} include "#{STR}"$/ do |dropdown, selector, expect, value|
  if expect == 'should'
    dropdown_should_include(dropdown, value, :within => selector)
  else
    dropdown_should_not_include(dropdown, value, :within => selector)
  end
end


# Verify that a dropdown includes or doesn't include all values in the given
# table or multiline string.
#
# Examples:
#
#   Then the "Height" dropdown should include:
#     | Short   |
#     | Average |
#     | Tall    |
#
#   Then the "Favorite Colors" dropdown should include:
#     """
#     Red
#     Green
#     Blue
#     """
#
Then /^the "#{STR}" dropdown#{WITHIN} #{SHOULD_OR_NOT} include:$/ do |dropdown, selector, expect, values|
  listify(values).each do |value|
    if expect == 'should'
      dropdown_should_include(dropdown, value, :within => selector)
    else
      dropdown_should_not_include(dropdown, value, :within => selector)
    end
  end
end


# Verify that a given field is empty or nil.
#
# Examples:
#
#   Then the "First name" field should be empty
#
Then /^the "#{STR}" field#{WITHIN} should be empty$/ do |field, selector|
  scope_within(selector) do
    field_should_be_empty field
  end
end


# Verify multiple fields in a form, optionally restricted to a given selector.
# Fields may be text inputs or dropdowns.
#
# Examples:
#
#   Then the fields should contain:
#     | First name | Eric   |
#     | Last name  | Pierce |
#
Then /^the fields#{WITHIN} should contain:$/ do |selector, fields|
  fields_should_contain_within(selector, fields.rows_hash)
end


# Verify that expected text exists or does not exist in the same row as
# some text. This can be used to ensure the presence or absence of "Edit"
# or "Delete" links, or specific data associated with a row in a table.
#
# Examples:
#
#   Then I should see "Edit" next to "John"
#   And I should not see "Delete" next to "John"
#
Then /^I #{SHOULD_OR_NOT} see "#{STR}" next to "#{STR}"#{WITHIN}$/ do |expect, text, next_to, selector|
  scope_within(selector) do
    if expect == 'should'
      should_see_in_same_row [text, next_to]
    else
      should_not_see_in_same_row [text, next_to]
    end
  end
end


# Verify that several expected text strings exist or do not exist in the same
# row as some text. Prevents multiple "should see X next to Y" calls. Similar
# to "should see a row containing", but targeted toward a specific row.
#
# Examples:
#
#   Then I should see the following next to "Terry":
#     | Copy   |
#     | Edit   |
#     | Delete |
#
#   Then I should see the following next to "John":
#     """
#     Copy
#     Edit
#     Delete
#     """
#
Then /^I #{SHOULD_OR_NOT} see the following next to "#{STR}"#{WITHIN}:$/ do |expect, next_to, selector, items|
  scope_within(selector) do
    listify(items).each do |text|
      if expect == 'should'
        should_see_in_same_row [text, next_to]
      else
        should_not_see_in_same_row [text, next_to]
      end
    end
  end
end


# Click a link in a table row that contains the given text.
# This can be used to click the "Edit" link for a specific record.
#
# Examples:
#
#   When I follow "Edit" next to "John"
#
When /^I follow "#{STR}" next to "#{STR}"$/ do |link, next_to|
  click_link_in_row(link, next_to)
end


# Verify that a checkbox in a certain table row is checked or unchecked.
# "should not be checked" and "should be unchecked" are equivalent, and
# "should be checked" and "should not be unchecked" are equivalent.
#
# Examples:
#
#   Then the "Like" checkbox next to "Apple" should be checked
#   And the "Like" checkbox next to "Banana" should be unchecked
#
Then /^the "#{STR}" checkbox next to "#{STR}"#{WITHIN} #{SHOULD_OR_NOT} be (checked|unchecked)$/ do |checkbox, next_to, selector, expect, state|

  within(:xpath, xpath_row_containing(next_to)) do
    if (expect == 'should' && state == 'checked') || (expect == 'should not' && state == 'unchecked')
      checkbox_should_be_checked(checkbox, :within => selector)
    else
      checkbox_should_not_be_checked(checkbox, :within => selector)
    end
  end
end

