module Htmlful
  module DynamicFields
    def add_remove_existing_sub_object_link_in_sub_form(sub_form, relationship_i18n_name)
      concat sub_form.input(:_destroy, :as => :hidden, :wrapper_html => {:class => 'remove'}, :input_html => {:class => "checkbox_remove"})
      concat content_tag(:li, link_to(t(:remove_nested_element, :resource_name => relationship_i18n_name), '#', :class => "remove_fieldset"))
    end

    def add_remove_and_create_new_nested_input_links(relationship_i18n_name)
      concat link_to(t(:remove_nested_element, :resource_name => relationship_i18n_name), '#', :class => "remove_element")
      concat link_to(t(:create_nested_element, :resource_name => relationship_i18n_name), "#", :class => "create_element")
    end

    def get_relationship_i18n_name(resource, relationship_name)
      resource.class.human_attribute_name(relationship_name) #.to_s
    end

    def create_dynamic_fields_form(form, resource, relationship_name, block1, block2)
      form.inputs :title => relationship_name do
        unless resource.send(relationship_name).empty?
          form.semantic_fields_for(relationship_name) do |sub_form|
            sub_form.inputs do
              block1.call(sub_form)
            end
          end
        end
        concat content_tag(:div, :class => "new_nested_element") {
          concat content_tag(:div, :class => "nested_inputs") {
            form.inputs do
              form.semantic_fields_for relationship_name, resource.send(relationship_name).build, :child_index => "NEW_RECORD" do |sub_form|
                block2.call(sub_form)
              end
            end
          }
          add_remove_and_create_new_nested_input_links(get_relationship_i18n_name(resource, relationship_name))
        }
      end
    end

    def dynamic_fields(form, resource, relationship_name, *attributes)
      block1 = lambda do |sub_form|
        sub_object = sub_form.object
        attributes.each do |attribute|
          if is_date?(sub_object, attribute)
            concat sub_form.input(attribute, :as => :string, :wrapper_html => {:class => 'datepick'})
            add_remove_existing_sub_object_link_in_sub_form(sub_form, get_relationship_i18n_name(resource, relationship_name))
          elsif is_datetime?(sub_object, attribute)
            concat sub_form.input(attribute, :include_blank => false)
            add_remove_existing_sub_object_link_in_sub_form(sub_form, get_relationship_i18n_name(resource, relationship_name))
          elsif is_document?(sub_object, attribute)
            if is_document_empty?(sub_object, attribute)
              # XXX Is this case is similar to an is_empty_image? If so it shouldn't show anything, if not remove the comments below
              # concat content_tag(:li, content_tag(:p, t(:no_document)))
              # add_remove_existing_sub_object_link_in_sub_form(sub_form, get_relationship_i18n_name(resource, relationship_name))
            else
              if is_image?(sub_object, attribute)
                if is_image_empty?(sub_object)
                  # XXX Do nohting, see is_empty_document? above
                else
                  image_opts = if sub_object.respond_to?(:geocoded?) && sub_object.geocoded?
                    { :class => "geo-photo", :"data-lat" => sub_object.latitude, :"data-lng" => sub_object.longitude }
                  else
                    {}
                  end
                  concat link_to(image_tag(sub_object.send(attribute).url(:thumb), image_opts), sub_object.send(attribute).url)
                  add_remove_existing_sub_object_link_in_sub_form(sub_form, get_relationship_i18n_name(resource, relationship_name))
                end
              else
                concat content_tag(:li, content_tag(:p, link_to(sub_object.send("#{attribute}_file_name"), sub_object.send(attribute).url)))
                add_remove_existing_sub_object_link_in_sub_form(sub_form, get_relationship_i18n_name(resource, relationship_name))
              end
            end
          else
            concat sub_form.input(attribute)
            add_remove_existing_sub_object_link_in_sub_form(sub_form, get_relationship_i18n_name(resource, relationship_name))
          end
        end
      end
      block2 = lambda do |sub_form|
        sub_object = sub_form.object
        attributes.each do |attribute|
          if is_date?(sub_object, attribute)
            concat sub_form.input(attribute, :as => :string, :wrapper_html => {:class => 'datepick ignore'})
          elsif is_datetime?(sub_object, attribute)
            concat sub_form.input(attribute, :include_blank => false)
          else
            concat sub_form.input(attribute) # takes care of everything else
          end
        end
      end
      create_dynamic_fields_form(form, resource, relationship_name, block1, block2)
    end

    def show_dynamic_fields(form, resource, relationship_name, *attributes)
      form.inputs :title => relationship_name do
        if resource.send(relationship_name).empty?
          concat t(:no_resource_name_plural, :resource_name_plural => resource.class.human_attribute_name(relationship_name, :count => 2).mb_chars.downcase)
        else
          form.semantic_fields_for(relationship_name) do |sub_form|
            sub_form.inputs do
              attributes.each do |attribute|
                concat show_attribute(sub_form, sub_form.object, attribute)
              end
            end
          end
        end
      end
    end

    # TODO: use concat and usage will be nicer
    def show_attribute_outside_form(resource, attribute, options=nil, &block)
      if is_date?(resource, attribute)
        resource.send(attribute) # TODO: add the controversial abbr method here, or just use title
      elsif is_document?(resource, attribute)
        if is_document_empty?(resource, attribute)
          t(:no_document)
        else
          if is_image?(resource, attribute)
            image_style = (options.nil? || options[:image_style].nil?)? :thumb : options[:image_style]
            image_tag(resource.send(attribute).url(image_style))
          else
            link_to(resource.send("#{attribute}_file_name"), resource.send(attribute).url)
          end
        end
      else
        yield
      end
    end

    # inside of a form
    def show_attribute(form, resource, attribute)
      if is_date?(resource, attribute)
        form.input(attribute, :as => :string, :wrapper_html => {:class => 'datepick'}, :input_html => {:disabled => true})
      elsif is_document?(resource, attribute)
        content_tag(:fieldset) do
          content_tag(:legend) do
            content_tag(:label, I18n.t("formtastic.labels.#{resource.class.name.underscore}.#{attribute}"))
          end +
            if is_document_empty?(resource, attribute)
            t(:no_document)
          else
            if is_image?(resource, attribute)
              image_tag(resource.send(attribute).url(:thumb))
            else
              link_to(resource.send("#{attribute}_file_name"), resource.send(attribute).url)
            end
          end
        end
      else
        form.input(attribute, :input_html => {:disabled => true})
      end
    end

    def show_subcollection(form, resource, association)
      collection = resource.send(association)
      resource_name_plural = localized_attribute_string(resource, association.to_sym)#resource.class.reflect_on_association(association.to_sym).klass.human_name(:count => 2)
      raise ("Translation missing #{params[:locale]}, #{resource.class.human_name}, #{association}") if resource_name_plural.nil?
      content_tag(:label, resource_name_plural) +
        if collection.empty?
        content_tag(:p, I18n.t(:no_resource_name_plural, :resource_name_plural => resource_name_plural.mb_chars.downcase))
      else
        content_tag(:ul, collection.inject("") { |html, sub_resource|
            html + content_tag(:li, link_to(sub_resource.send(form.send(:detect_label_method, [sub_resource])), sub_resource))
          }, :class => "sub-collection")
      end
    end

    def multi_select_input(form, association, options={})
      form.input(association, options) + content_tag(:li, content_tag(:div, link_to(t(:clear_selected), "#", :class => "clear_multi_select"), :class => "clear_multi_select"))
    end

    def form_inputs(form, *attributes)
      options = attributes.extract_options!
      resource = form.object
      returning("") do |html|
        attributes.each do |attribute|
          html << form.input(attribute)
          if is_document?(resource, attribute)
            unless is_document_empty?(resource, attribute)
              html << "<li>"
              if is_image?(resource, attribute)
                image_style = (options.nil? || options[:image_style].nil?)? :thumb : options[:image_style]
                html << image_tag(form.object.send(attribute).url(image_style))
              else
                html << link_to(sub_object.send("#{attribute}_file_name"), resource.send(attribute).url)
              end
              html << content_tag(:br)
              html << content_tag(:a, t(:delete_resource, :resource => resource.class.human_attribute_name(attribute)), :href => "#", :class => "delete_document #{resource.class.name.underscore} #{attribute}")
              html << "</li>"
            end
          end
        end
      end
    end

    protected

    ## copied and adapted from formtastic
    def localized_attribute_string(resource, attr_name)
      model_name = resource.class.name.underscore
      action_name = template.params[:action].to_s rescue ''
      attribute_name = attr_name.to_s

      i18n_scopes = ['{{model}}.{{action}}.{{attribute}}', '{{model}}.{{attribute}}', '{{attribute}}']
      defaults = i18n_scopes.collect do |i18n_scope|
        i18n_path = i18n_scope.dup
        i18n_path.gsub!('{{action}}', action_name)
        i18n_path.gsub!('{{model}}', model_name)
        i18n_path.gsub!('{{attribute}}', attribute_name)
        i18n_path.gsub!('..', '.')
        i18n_path.to_sym
      end
      defaults << ''

      i18n_value = ::I18n.t(defaults.shift, :default => defaults, :scope => "formtastic.labels")
      i18n_value.blank? ? nil : i18n_value
    end

    def is_date?(resource, attribute)
      col = resource.column_for_attribute(attribute)
      col && col.type == :date
    end

    def is_datetime?(resource, attribute)
      col = resource.column_for_attribute(attribute)
      col && col.type == :datetime
    end

    # taken from formtastic
    @@file_methods = [:file?, :public_filename]
    def is_document?(resource, attribute)
      file = resource.send(attribute) if resource.respond_to?(attribute)
      file && @@file_methods.any? { |m| file.respond_to?(m) }
    end

    def is_document_empty?(resource, attribute)
      resource.send("#{attribute}_file_name").blank?
    end

    def is_image_empty?(resource)
      resource.new_record?
    end

    # XXX: if image is missing, this will return false because it queries the styles. Find out what we want
    def is_image?(resource, attribute)
      file = resource.send(attribute) if resource.respond_to?(attribute)
      is_document?(resource, attribute) && file && file.respond_to?(:styles) && !file.styles.blank?
    end
  end
end
