local gui_names = {}
local gui_captions = {}

--local gui_captions.= {}
-- Defines. Mostly GUI element names.
gui_names.settings_container = "message-broadcaster.settings_container"

gui_names.settings_subcontainer_right = "message-broadcaster.settings_subcontainer_right"

gui_names.settings_frame = "message-broadcaster.settings_frame"

gui_names.settings_current_frame = "message-broadcaster.settings_current_frame"
gui_names.settings_current_table = "message-broadcaster.settings_current_table"
gui_names.settings_current_message_label = "message-broadcaster.settings_current_message_label"
gui_names.settings_current_color_container = "message-broadcaster.settings_current_color_container"
gui_names.settings_current_color_label = "message-broadcaster.settings_current_color_label"
gui_names.settings_current_color_value_label = "message-broadcaster.settings_current_color_value_label"
gui_names.settings_current_target_force_label = "message-broadcaster.settings_current_target_force_label"
gui_names.settings_current_target_distance_label = "message-broadcaster.settings_current_target_distance_label"
gui_names.settings_current_method_label = "message-broadcaster.settings_current_method_label"

gui_names.settings_message_label_container = "message-broadcaster.settings_message_label_container"
gui_names.settings_message_label = "message-broadcaster.settings_message_label"
gui_names.settings_message_hint_button = "message-broadcaster.settings_message_hint_button"
gui_names.settings_message_textfield = "message-broadcaster.settings_message_textfield"
gui_names.settings_message_color_container = "message-broadcaster.settings_message_color_container"
gui_names.settings_message_color_label = "message-broadcaster.settings_message_color_label"
gui_names.settings_message_color_value_label = "message-broadcaster.settings_message_color_value_label"
gui_names.settings_message_pick_color_button = "message-broadcaster.settings_message_pick_color_button"

gui_names.settings_target_and_method_container = "message-broadcaster.settings_target_and_method_container"
gui_names.settings_target_container = "message-broadcaster.settings_target_container"

gui_names.settings_target_force_label = "message-broadcaster.settings_target_force_label"
gui_names.settings_target_force_table = "message-broadcaster.settings_target_force_table"
gui_names.settings_target_same_force_checkbox = "message-broadcaster.settings_target_same_force_checkbox"
gui_names.settings_target_all_forces_checkbox = "message-broadcaster.settings_target_all_forces_checkbox"

gui_names.settings_target_distance_label = "message-broadcaster.settings_target_distance_label"
gui_names.settings_target_distance_table = "message-broadcaster.settings_target_distance_table"
gui_names.settings_target_players_nearby_checkbox = "message-broadcaster.settings_target_players_nearby_checkbox"
gui_names.settings_target_same_surface_checkbox = "message-broadcaster.settings_target_same_surface_checkbox"
gui_names.settings_target_all_players_checkbox = "message-broadcaster.settings_target_all_players_checkbox"

gui_names.settings_method_container = "message-broadcaster.settings_method_container"
gui_names.settings_method_table = "message-broadcaster.settings_method_table"
gui_names.settings_method_console_checkbox = "message-broadcaster.settings_method_console_checkbox"
gui_names.settings_method_flying_text_checkbox = "message-broadcaster.settings_method_flying_text_checkbox"
gui_names.settings_method_popup_checkbox = "message-broadcaster.settings_method_popup_checkbox"
gui_names.settings_method_playsound_checkbox = "message-broadcaster.settings_method_playsound_checkbox"
gui_names.settings_method_usemapmark_checkbox = "message-broadcaster.settings_method_usemapmark_checkbox"


gui_names.settings_apply_and_reload_container = "message-broadcaster.settings_apply_and_reload_container"
gui_names.settings_apply_button = "message-broadcaster.settings_apply_button"
gui_names.settings_apply_and_reload_left_space = "message-broadcaster.settings_apply_and_reload_left_space"
gui_names.settings_reload_button = "message-broadcaster.settings_reload_button"
gui_names.settings_test_button = "message-broadcaster.settings_test_button"

gui_names.message_hint_container = "message-broadcaster_message-hint-container"
gui_names.message_hint_frame = "message-broadcaster_message-hint-frame"
gui_names.message_hint_table = "message-broadcaster_message-hint-table"
gui_names.message_hint_labels_prefix = "message-broadcaster_message-hint-label-"
gui_names.color_picker_container = "message-broadcaster_color-picker"

gui_names.received_message_popup_frame = "message-broadcaster_received-message-popup-frame"
gui_names.received_message_popup_table = "message-broadcaster_received-message-popup-table"
gui_names.received_message_popup_inner_frame_prefix = "message-broadcaster_received-message-popup-inner-frame-"
gui_names.received_message_popup_label = "message-broadcaster_received-message-popup-label"
gui_names.received_message_popup_button_container = "message-broadcaster_received-message-popup-button-container"
gui_names.received_message_popup_button_space = "message-broadcaster_received-message-popup-button-space"
gui_names.received_message_popup_button = "message-broadcaster_received-message-popup-button"

-- Captions.

gui_captions.target_forces = {}
table.insert(gui_captions.target_forces, {"gui.message-broadcaster_same-force"})
table.insert(gui_captions.target_forces, {"gui.message-broadcaster_all-force"})

gui_captions.target_distances = {}
table.insert(gui_captions.target_distances, {"gui.message-broadcaster_players-nearby"})
table.insert(gui_captions.target_distances, {"gui.message-broadcaster_players-on-same-surface"})
table.insert(gui_captions.target_distances, {"gui.message-broadcaster_all-players"})

gui_captions.methods = {}
table.insert(gui_captions.methods, {"gui.message-broadcaster_console"})
table.insert(gui_captions.methods, {"gui.message-broadcaster_flying-text"})
table.insert(gui_captions.methods, {"gui.message-broadcaster_popup"})
table.insert(gui_captions.methods, {"gui.message-broadcaster_playsound"})
table.insert(gui_captions.methods, {"gui.message-broadcaster_usemapmark"})

return function() return gui_names, gui_captions end