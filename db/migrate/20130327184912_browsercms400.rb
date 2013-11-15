class Browsercms400 < ActiveRecord::Migration

  def up
    add_column prefix(:section_nodes), :slug, :string
    add_content_column prefix(:dynamic_views), :path, :string
    add_content_column prefix(:dynamic_views), :locale, :string, default: 'en'
    add_content_column prefix(:dynamic_views), :partial, :boolean, default: false

    Cms::PageTemplate.all.find_each do |pt|
      pt.path = "layout/templates/#{pt.name}"
      pt.locale = "en"
      pt.save!
    end

    Cms::PagePartial.all.find_each do |pp|
      pp.path = "partials/#{pp.name}"
      pp.locale = "en"
      pp.partial = true
      pp.save!
    end

    drop_table prefix(:content_type_groups)
    drop_table prefix(:content_types)

    create_content_table :forms do |t|
      t.string :name
      t.text :description
      t.string :confirmation_behavior
      t.text :confirmation_text
      t.string :confirmation_redirect
      t.string :notification_email
    end

    create_table :cms_form_fields do |t|
      t.integer :form_id
      t.string :label
      t.string :name
      t.string :field_type
      t.boolean :required
      t.integer :position
      t.text :instructions
      t.text :default_value
      t.timestamps
    end

    # Field names should be unique per form
    add_index :cms_form_fields, [:form_id, :name], :unique => true

    create_table :cms_form_entries do |t|
      t.text :data_columns
      t.integer :form_id
      t.timestamps
    end


  end
end
