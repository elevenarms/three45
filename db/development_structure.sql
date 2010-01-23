CREATE TABLE `ad_clicks` (
  `id` varchar(36) NOT NULL,
  `ad_id` varchar(36) NOT NULL,
  `user_id` varchar(255) default NULL,
  `deleted_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `ad_id` (`ad_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `ad_clicks_ibfk_1` FOREIGN KEY (`ad_id`) REFERENCES `ads` (`id`),
  CONSTRAINT `ad_clicks_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `ad_views` (
  `id` varchar(36) NOT NULL,
  `ad_id` varchar(36) NOT NULL,
  `user_id` varchar(255) default NULL,
  `deleted_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `ad_id` (`ad_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `ad_views_ibfk_1` FOREIGN KEY (`ad_id`) REFERENCES `ads` (`id`),
  CONSTRAINT `ad_views_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `address_types` (
  `id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `deleted_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `addresses` (
  `id` varchar(36) NOT NULL,
  `street1` varchar(255) NOT NULL,
  `street2` varchar(255) default NULL,
  `city` varchar(255) NOT NULL,
  `state` varchar(255) NOT NULL,
  `latlng` varchar(255) default NULL,
  `deleted_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `zip_code` varchar(255) default NULL,
  `plus_four_code` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `ads` (
  `id` varchar(36) NOT NULL,
  `workgroup_id` varchar(36) default NULL,
  `image_path` varchar(255) default NULL,
  `link_url` varchar(255) default NULL,
  `deleted_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `workgroup_id` (`workgroup_id`),
  CONSTRAINT `ads_ibfk_1` FOREIGN KEY (`workgroup_id`) REFERENCES `workgroups` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `audit_categories` (
  `id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `audit_logs` (
  `id` varchar(36) NOT NULL,
  `audit_category_id` varchar(36) NOT NULL,
  `description` varchar(255) default NULL,
  `user_id` varchar(36) default NULL,
  `profile_id` varchar(36) default NULL,
  `referral_id` varchar(36) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `workgroup_id` varchar(36) default NULL,
  `long_description` text,
  PRIMARY KEY  (`id`),
  KEY `audit_category_id` (`audit_category_id`),
  KEY `workgroup_id` (`workgroup_id`),
  CONSTRAINT `audit_logs_ibfk_1` FOREIGN KEY (`audit_category_id`) REFERENCES `audit_categories` (`id`),
  CONSTRAINT `audit_logs_ibfk_2` FOREIGN KEY (`workgroup_id`) REFERENCES `workgroups` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `cpt_codes` (
  `id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `dashboard_filters` (
  `id` varchar(36) NOT NULL,
  `user_id` varchar(255) default NULL,
  `filter_direction` varchar(255) default NULL,
  `filter_owner` varchar(255) default NULL,
  `filter_type` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `dashboard_filters_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `group_roles` (
  `id` varchar(36) NOT NULL,
  `group_id` varchar(36) NOT NULL,
  `role_id` varchar(36) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `group_id` (`group_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `group_roles_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`),
  CONSTRAINT `group_roles_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `groups` (
  `id` varchar(36) NOT NULL,
  `workgroup_type_id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `workgroup_type_id` (`workgroup_type_id`),
  CONSTRAINT `groups_ibfk_1` FOREIGN KEY (`workgroup_type_id`) REFERENCES `workgroup_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `icd9_codes` (
  `id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `mime_types` (
  `id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `profile_blocked_friendships` (
  `id` varchar(36) NOT NULL,
  `source_profile_id` varchar(36) NOT NULL,
  `target_profile_id` varchar(36) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `source_profile_id` (`source_profile_id`),
  KEY `target_profile_id` (`target_profile_id`),
  CONSTRAINT `profile_blocked_friendships_ibfk_1` FOREIGN KEY (`source_profile_id`) REFERENCES `profiles` (`id`),
  CONSTRAINT `profile_blocked_friendships_ibfk_2` FOREIGN KEY (`target_profile_id`) REFERENCES `profiles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `profile_friendships` (
  `id` varchar(36) NOT NULL,
  `source_profile_id` varchar(36) NOT NULL,
  `target_profile_id` varchar(36) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  `blocked_by_source_at` datetime default NULL,
  `blocked_by_target_at` datetime default NULL,
  `created_by_profile_id` varchar(36) default NULL,
  PRIMARY KEY  (`id`),
  KEY `source_profile_id` (`source_profile_id`),
  KEY `target_profile_id` (`target_profile_id`),
  KEY `created_by_profile_id` (`created_by_profile_id`),
  CONSTRAINT `profile_friendships_ibfk_1` FOREIGN KEY (`source_profile_id`) REFERENCES `profiles` (`id`),
  CONSTRAINT `profile_friendships_ibfk_2` FOREIGN KEY (`target_profile_id`) REFERENCES `profiles` (`id`),
  CONSTRAINT `profile_friendships_ibfk_3` FOREIGN KEY (`created_by_profile_id`) REFERENCES `profiles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `profile_images` (
  `id` varchar(36) NOT NULL,
  `profile_id` varchar(36) NOT NULL,
  `size` int(11) default NULL,
  `content_type` varchar(255) default NULL,
  `filename` varchar(255) default NULL,
  `height` int(11) default NULL,
  `width` int(11) default NULL,
  `parent_id` varchar(36) default NULL,
  `thumbnail` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `profile_id` (`profile_id`),
  CONSTRAINT `profile_images_ibfk_1` FOREIGN KEY (`profile_id`) REFERENCES `profiles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `profile_tags` (
  `id` varchar(36) NOT NULL,
  `profile_id` varchar(36) NOT NULL,
  `tag_type_id` varchar(36) NOT NULL,
  `tag_id` varchar(36) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `profile_id` (`profile_id`),
  KEY `tag_type_id` (`tag_type_id`),
  KEY `tag_id` (`tag_id`),
  CONSTRAINT `profile_tags_ibfk_1` FOREIGN KEY (`profile_id`) REFERENCES `profiles` (`id`),
  CONSTRAINT `profile_tags_ibfk_2` FOREIGN KEY (`tag_type_id`) REFERENCES `tag_types` (`id`),
  CONSTRAINT `profile_tags_ibfk_3` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `profile_types` (
  `id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `profiles` (
  `id` varchar(36) NOT NULL,
  `profile_type_id` varchar(36) NOT NULL,
  `display_name` varchar(255) NOT NULL,
  `user_id` varchar(36) default NULL,
  `workgroup_id` varchar(36) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  `description` text,
  `npi_identifier` varchar(20) default NULL,
  `medical_license_id` varchar(20) default NULL,
  `notify_email` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `profile_type_id` (`profile_type_id`),
  KEY `user_id` (`user_id`),
  KEY `workgroup_id` (`workgroup_id`),
  CONSTRAINT `profiles_ibfk_1` FOREIGN KEY (`profile_type_id`) REFERENCES `profile_types` (`id`),
  CONSTRAINT `profiles_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `profiles_ibfk_3` FOREIGN KEY (`workgroup_id`) REFERENCES `workgroups` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `referral_diagnosis_selections` (
  `id` varchar(36) NOT NULL,
  `referral_id` varchar(36) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  `tag_type_id` varchar(36) default NULL,
  `tag_id` varchar(36) default NULL,
  PRIMARY KEY  (`id`),
  KEY `referral_id` (`referral_id`),
  KEY `tag_type_id` (`tag_type_id`),
  KEY `tag_id` (`tag_id`),
  CONSTRAINT `referral_diagnosis_selections_ibfk_1` FOREIGN KEY (`referral_id`) REFERENCES `referrals` (`id`),
  CONSTRAINT `referral_diagnosis_selections_ibfk_2` FOREIGN KEY (`tag_type_id`) REFERENCES `tag_types` (`id`),
  CONSTRAINT `referral_diagnosis_selections_ibfk_3` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `referral_fax_content_selections` (
  `id` varchar(36) NOT NULL,
  `referral_fax_id` varchar(36) NOT NULL,
  `tag_id` varchar(36) NOT NULL,
  `other_text` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `referral_fax_id` (`referral_fax_id`),
  KEY `tag_id` (`tag_id`),
  CONSTRAINT `referral_fax_content_selections_ibfk_1` FOREIGN KEY (`referral_fax_id`) REFERENCES `referral_faxes` (`id`),
  CONSTRAINT `referral_fax_content_selections_ibfk_2` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `referral_fax_files` (
  `id` varchar(36) NOT NULL,
  `referral_id` varchar(36) NOT NULL,
  `referral_fax_id` varchar(36) NOT NULL,
  `size` int(11) default NULL,
  `content_type` varchar(255) default NULL,
  `filename` varchar(255) default NULL,
  `height` int(11) default NULL,
  `width` int(11) default NULL,
  `parent_id` varchar(36) default NULL,
  `thumbnail` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `referral_id` (`referral_id`),
  KEY `referral_fax_id` (`referral_fax_id`),
  CONSTRAINT `referral_fax_files_ibfk_1` FOREIGN KEY (`referral_id`) REFERENCES `referrals` (`id`),
  CONSTRAINT `referral_fax_files_ibfk_2` FOREIGN KEY (`referral_fax_id`) REFERENCES `referral_faxes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `referral_fax_states` (
  `id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `referral_faxes` (
  `id` varchar(36) NOT NULL,
  `referral_id` varchar(36) NOT NULL,
  `referral_fax_state_id` varchar(36) NOT NULL,
  `page_count` int(11) default NULL,
  `comments` varchar(255) default NULL,
  `filename` varchar(255) default NULL,
  `error_details` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  `referral_message_id` varchar(36) default NULL,
  PRIMARY KEY  (`id`),
  KEY `referral_id` (`referral_id`),
  KEY `referral_fax_state_id` (`referral_fax_state_id`),
  KEY `referral_message_id` (`referral_message_id`),
  CONSTRAINT `referral_faxes_ibfk_1` FOREIGN KEY (`referral_id`) REFERENCES `referrals` (`id`),
  CONSTRAINT `referral_faxes_ibfk_2` FOREIGN KEY (`referral_fax_state_id`) REFERENCES `referral_fax_states` (`id`),
  CONSTRAINT `referral_faxes_ibfk_3` FOREIGN KEY (`referral_message_id`) REFERENCES `referral_messages` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `referral_file_types` (
  `id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `referral_files` (
  `id` varchar(36) NOT NULL,
  `referral_id` varchar(36) NOT NULL,
  `referral_file_type_id` varchar(36) NOT NULL,
  `mime_type_id` varchar(36) NOT NULL,
  `description` varchar(255) default NULL,
  `reference_date` date default NULL,
  `comment_text` varchar(255) default NULL,
  `size` int(11) default NULL,
  `content_type` varchar(255) default NULL,
  `filename` varchar(255) default NULL,
  `height` int(11) default NULL,
  `width` int(11) default NULL,
  `parent_id` varchar(36) default NULL,
  `thumbnail` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  `referral_message_id` varchar(36) default NULL,
  PRIMARY KEY  (`id`),
  KEY `referral_id` (`referral_id`),
  KEY `referral_file_type_id` (`referral_file_type_id`),
  KEY `mime_type_id` (`mime_type_id`),
  KEY `referral_message_id` (`referral_message_id`),
  CONSTRAINT `referral_files_ibfk_1` FOREIGN KEY (`referral_id`) REFERENCES `referrals` (`id`),
  CONSTRAINT `referral_files_ibfk_2` FOREIGN KEY (`referral_file_type_id`) REFERENCES `referral_file_types` (`id`),
  CONSTRAINT `referral_files_ibfk_3` FOREIGN KEY (`mime_type_id`) REFERENCES `mime_types` (`id`),
  CONSTRAINT `referral_files_ibfk_4` FOREIGN KEY (`referral_message_id`) REFERENCES `referral_messages` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `referral_insurance_plans` (
  `id` varchar(36) NOT NULL,
  `referral_id` varchar(36) NOT NULL,
  `insurance_carrier_tag_id` varchar(36) default NULL,
  `insurance_carrier_plan_tag_id` varchar(36) default NULL,
  `policy_details` varchar(255) default NULL,
  `deleted_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `authorization` varchar(255) default NULL,
  `number_of_visits` int(11) default NULL,
  `expiration_date` date default NULL,
  PRIMARY KEY  (`id`),
  KEY `referral_id` (`referral_id`),
  KEY `insurance_carrier_tag_id` (`insurance_carrier_tag_id`),
  KEY `insurance_carrier_plan_tag_id` (`insurance_carrier_plan_tag_id`),
  CONSTRAINT `referral_insurance_plans_ibfk_1` FOREIGN KEY (`referral_id`) REFERENCES `referrals` (`id`),
  CONSTRAINT `referral_insurance_plans_ibfk_2` FOREIGN KEY (`insurance_carrier_tag_id`) REFERENCES `tags` (`id`),
  CONSTRAINT `referral_insurance_plans_ibfk_3` FOREIGN KEY (`insurance_carrier_plan_tag_id`) REFERENCES `tags` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `referral_message_states` (
  `id` varchar(36) NOT NULL,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `referral_message_subtype_selections` (
  `id` varchar(36) NOT NULL,
  `referral_id` varchar(36) NOT NULL,
  `referral_message_id` varchar(36) NOT NULL,
  `referral_message_subtype_id` varchar(36) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `referral_id` (`referral_id`),
  KEY `referral_message_id` (`referral_message_id`),
  KEY `referral_message_subtype_id` (`referral_message_subtype_id`),
  CONSTRAINT `referral_message_subtype_selections_ibfk_1` FOREIGN KEY (`referral_id`) REFERENCES `referrals` (`id`),
  CONSTRAINT `referral_message_subtype_selections_ibfk_2` FOREIGN KEY (`referral_message_id`) REFERENCES `referral_messages` (`id`),
  CONSTRAINT `referral_message_subtype_selections_ibfk_3` FOREIGN KEY (`referral_message_subtype_id`) REFERENCES `referral_message_subtypes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `referral_message_subtypes` (
  `id` varchar(36) NOT NULL,
  `referral_message_type_id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `referral_message_type_id` (`referral_message_type_id`),
  CONSTRAINT `referral_message_subtypes_ibfk_1` FOREIGN KEY (`referral_message_type_id`) REFERENCES `referral_message_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `referral_message_types` (
  `id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `referral_messages` (
  `id` varchar(36) NOT NULL,
  `referral_id` varchar(36) NOT NULL,
  `referral_message_type_id` varchar(36) NOT NULL,
  `message_text` text,
  `response_required_by` datetime default NULL,
  `responded_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  `referral_source_or_target_id` varchar(36) default NULL,
  `referral_message_state_id` varchar(255) default NULL,
  `subject` varchar(255) default NULL,
  `reply_to_message_id` varchar(255) default NULL,
  `created_by_user_id` varchar(255) default NULL,
  `viewed_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `referral_id` (`referral_id`),
  KEY `referral_message_type_id` (`referral_message_type_id`),
  KEY `referral_message_state_id` (`referral_message_state_id`),
  KEY `reply_to_message_id` (`reply_to_message_id`),
  KEY `created_by_user_id` (`created_by_user_id`),
  CONSTRAINT `referral_messages_ibfk_1` FOREIGN KEY (`referral_id`) REFERENCES `referrals` (`id`),
  CONSTRAINT `referral_messages_ibfk_2` FOREIGN KEY (`referral_message_type_id`) REFERENCES `referral_message_types` (`id`),
  CONSTRAINT `referral_messages_ibfk_5` FOREIGN KEY (`referral_message_state_id`) REFERENCES `referral_message_states` (`id`),
  CONSTRAINT `referral_messages_ibfk_6` FOREIGN KEY (`reply_to_message_id`) REFERENCES `referral_messages` (`id`),
  CONSTRAINT `referral_messages_ibfk_7` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `referral_patients` (
  `id` varchar(36) NOT NULL,
  `referral_id` varchar(36) NOT NULL,
  `first_name` varchar(255) default NULL,
  `middle_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `ssn` varchar(255) default NULL,
  `dob` date default NULL,
  `gender` varchar(1) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  `phone` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `referral_id` (`referral_id`),
  CONSTRAINT `referral_patients_ibfk_1` FOREIGN KEY (`referral_id`) REFERENCES `referrals` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `referral_reasons` (
  `id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `referral_source_states` (
  `id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `referral_sources` (
  `id` varchar(36) NOT NULL,
  `referral_id` varchar(36) NOT NULL,
  `referral_source_state_id` varchar(36) NOT NULL,
  `workgroup_id` varchar(36) NOT NULL,
  `user_id` varchar(36) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `referral_id` (`referral_id`),
  KEY `referral_source_state_id` (`referral_source_state_id`),
  KEY `workgroup_id` (`workgroup_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `referral_sources_ibfk_1` FOREIGN KEY (`referral_id`) REFERENCES `referrals` (`id`),
  CONSTRAINT `referral_sources_ibfk_2` FOREIGN KEY (`referral_source_state_id`) REFERENCES `referral_source_states` (`id`),
  CONSTRAINT `referral_sources_ibfk_3` FOREIGN KEY (`workgroup_id`) REFERENCES `workgroups` (`id`),
  CONSTRAINT `referral_sources_ibfk_4` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `referral_states` (
  `id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `referral_studies` (
  `id` varchar(36) NOT NULL,
  `referral_id` varchar(36) NOT NULL,
  `study_type_tag_id` varchar(36) NOT NULL,
  `location_tag_id` varchar(36) NOT NULL,
  `location_detail_tag_id` varchar(36) NOT NULL,
  `additional_comments` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  `study_modality_tag_id` varchar(36) default NULL,
  `body_part` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `referral_id` (`referral_id`),
  KEY `study_type_tag_id` (`study_type_tag_id`),
  KEY `location_tag_id` (`location_tag_id`),
  KEY `location_detail_tag_id` (`location_detail_tag_id`),
  KEY `study_modality_tag_id` (`study_modality_tag_id`),
  CONSTRAINT `referral_studies_ibfk_1` FOREIGN KEY (`referral_id`) REFERENCES `referrals` (`id`),
  CONSTRAINT `referral_studies_ibfk_2` FOREIGN KEY (`study_type_tag_id`) REFERENCES `tags` (`id`),
  CONSTRAINT `referral_studies_ibfk_4` FOREIGN KEY (`location_tag_id`) REFERENCES `tags` (`id`),
  CONSTRAINT `referral_studies_ibfk_5` FOREIGN KEY (`location_detail_tag_id`) REFERENCES `tags` (`id`),
  CONSTRAINT `referral_studies_ibfk_6` FOREIGN KEY (`study_modality_tag_id`) REFERENCES `tags` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `referral_target_states` (
  `id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `referral_targets` (
  `id` varchar(36) NOT NULL,
  `referral_id` varchar(36) NOT NULL,
  `referral_target_state_id` varchar(36) NOT NULL,
  `workgroup_id` varchar(36) NOT NULL,
  `user_id` varchar(36) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  `display_name` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `referral_id` (`referral_id`),
  KEY `referral_target_state_id` (`referral_target_state_id`),
  KEY `workgroup_id` (`workgroup_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `referral_targets_ibfk_1` FOREIGN KEY (`referral_id`) REFERENCES `referrals` (`id`),
  CONSTRAINT `referral_targets_ibfk_2` FOREIGN KEY (`referral_target_state_id`) REFERENCES `referral_target_states` (`id`),
  CONSTRAINT `referral_targets_ibfk_3` FOREIGN KEY (`workgroup_id`) REFERENCES `workgroups` (`id`),
  CONSTRAINT `referral_targets_ibfk_4` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `referral_type_selections` (
  `id` varchar(36) NOT NULL,
  `referral_id` varchar(36) NOT NULL,
  `tag_type_id` varchar(36) NOT NULL,
  `tag_id` varchar(36) NOT NULL,
  `diagnosis_text` text,
  `additional_instructions` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `referral_id` (`referral_id`),
  KEY `tag_type_id` (`tag_type_id`),
  KEY `tag_id` (`tag_id`),
  CONSTRAINT `referral_type_selections_ibfk_1` FOREIGN KEY (`referral_id`) REFERENCES `referrals` (`id`),
  CONSTRAINT `referral_type_selections_ibfk_2` FOREIGN KEY (`tag_type_id`) REFERENCES `tag_types` (`id`),
  CONSTRAINT `referral_type_selections_ibfk_3` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `referrals` (
  `id` varchar(36) NOT NULL,
  `referral_state_id` varchar(36) NOT NULL,
  `referral_reason_id` varchar(36) default NULL,
  `cpt_code_id` varchar(36) default NULL,
  `icd9_code_id` varchar(36) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  `created_by_user_id` varchar(36) NOT NULL,
  `active_source_id` varchar(36) default NULL,
  `active_target_id` varchar(36) default NULL,
  `wizard_step` varchar(255) default NULL,
  `from_name` varchar(255) default NULL,
  `to_name` varchar(255) default NULL,
  `created_by_workgroup_id` varchar(36) default NULL,
  `request_flag` tinyint(1) default '0',
  PRIMARY KEY  (`id`),
  KEY `referral_state_id` (`referral_state_id`),
  KEY `referral_reason_id` (`referral_reason_id`),
  KEY `cpt_code_id` (`cpt_code_id`),
  KEY `icd9_code_id` (`icd9_code_id`),
  KEY `created_by_user_id` (`created_by_user_id`),
  KEY `active_source_id` (`active_source_id`),
  KEY `active_target_id` (`active_target_id`),
  KEY `created_by_workgroup_id` (`created_by_workgroup_id`),
  CONSTRAINT `referrals_ibfk_1` FOREIGN KEY (`referral_state_id`) REFERENCES `referral_states` (`id`),
  CONSTRAINT `referrals_ibfk_10` FOREIGN KEY (`created_by_workgroup_id`) REFERENCES `workgroups` (`id`),
  CONSTRAINT `referrals_ibfk_4` FOREIGN KEY (`referral_reason_id`) REFERENCES `referral_reasons` (`id`),
  CONSTRAINT `referrals_ibfk_5` FOREIGN KEY (`cpt_code_id`) REFERENCES `cpt_codes` (`id`),
  CONSTRAINT `referrals_ibfk_6` FOREIGN KEY (`icd9_code_id`) REFERENCES `icd9_codes` (`id`),
  CONSTRAINT `referrals_ibfk_7` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `referrals_ibfk_8` FOREIGN KEY (`active_source_id`) REFERENCES `referral_sources` (`id`),
  CONSTRAINT `referrals_ibfk_9` FOREIGN KEY (`active_target_id`) REFERENCES `referral_targets` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `registrations` (
  `id` varchar(36) NOT NULL,
  `subdomain` varchar(255) default NULL,
  `workgroup_name` varchar(255) default NULL,
  `workgroup_id` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `first_name` varchar(255) default NULL,
  `login` varchar(255) default NULL,
  `user_id` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `password` varchar(255) default NULL,
  `physician_reg` tinyint(1) default '0',
  `card_type` varchar(255) default NULL,
  `card_number` varchar(255) default NULL,
  `billing_zip_code` varchar(255) default NULL,
  `expiration_month` varchar(255) default NULL,
  `expiration_year` varchar(255) default NULL,
  `num_physicians` int(11) default NULL,
  `physician_first_name` varchar(255) default NULL,
  `physician_middle_name` varchar(255) default NULL,
  `physician_last_name` varchar(255) default NULL,
  `physician_npi` varchar(255) default NULL,
  `physician_med_license` varchar(255) default NULL,
  `physician_uid` varchar(255) default NULL,
  `office_phone` varchar(255) default NULL,
  `office_fax` varchar(255) default NULL,
  `plan` varchar(255) default NULL,
  `fee` varchar(255) default NULL,
  `comments` text,
  `status_code` varchar(255) default NULL,
  `deleted_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  KEY `workgroup_id` (`workgroup_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `registrations_ibfk_1` FOREIGN KEY (`workgroup_id`) REFERENCES `workgroups` (`id`),
  CONSTRAINT `registrations_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `roles` (
  `id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `session_id` varchar(255) default NULL,
  `data` text,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB AUTO_INCREMENT=753 DEFAULT CHARSET=latin1;

CREATE TABLE `tag_logos` (
  `id` varchar(36) NOT NULL,
  `tag_id` varchar(36) NOT NULL,
  `path` varchar(255) default NULL,
  `height` int(11) default NULL,
  `width` int(11) default NULL,
  `deleted_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tag_sponsor_clicks` (
  `id` varchar(36) NOT NULL,
  `tag_sponsor_id` varchar(36) NOT NULL,
  `user_id` varchar(36) NOT NULL,
  `deleted_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tag_sponsor_views` (
  `id` varchar(36) NOT NULL,
  `tag_sponsor_id` varchar(36) NOT NULL,
  `user_id` varchar(36) NOT NULL,
  `deleted_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tag_sponsors` (
  `id` varchar(36) NOT NULL,
  `tag_id` varchar(36) NOT NULL,
  `name` varchar(255) default NULL,
  `image_path` varchar(255) default NULL,
  `link_url` varchar(255) default NULL,
  `deleted_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `detail_text` text,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tag_types` (
  `id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `deleted_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `show_details_flag` tinyint(1) default NULL,
  `parent_tag_type_id` varchar(36) default NULL,
  PRIMARY KEY  (`id`),
  KEY `parent_tag_type_id` (`parent_tag_type_id`),
  CONSTRAINT `tag_types_ibfk_1` FOREIGN KEY (`parent_tag_type_id`) REFERENCES `tag_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tag_views` (
  `id` varchar(36) NOT NULL,
  `tag_id` varchar(36) NOT NULL,
  `user_id` varchar(36) NOT NULL,
  `deleted_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tags` (
  `id` varchar(36) NOT NULL,
  `tag_type_id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `deleted_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `contact_details` varchar(255) default NULL,
  `detail_text` text,
  `parent_tag_id` varchar(36) default NULL,
  PRIMARY KEY  (`id`),
  KEY `parent_tag_id` (`parent_tag_id`),
  CONSTRAINT `tags_ibfk_1` FOREIGN KEY (`parent_tag_id`) REFERENCES `tags` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `user_groups` (
  `id` varchar(36) NOT NULL,
  `user_id` varchar(36) NOT NULL,
  `group_id` varchar(36) NOT NULL,
  `deleted_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `user_id` (`user_id`),
  KEY `group_id` (`group_id`),
  CONSTRAINT `user_groups_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `user_groups_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `user_workgroup_addresses` (
  `id` varchar(36) NOT NULL,
  `workgroup_address_id` varchar(36) NOT NULL,
  `user_id` varchar(36) NOT NULL,
  `deleted_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `users` (
  `id` varchar(36) NOT NULL,
  `login` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `crypted_password` varchar(40) default NULL,
  `salt` varchar(40) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `remember_token` varchar(255) default NULL,
  `remember_token_expires_at` datetime default NULL,
  `last_login_at` datetime default NULL,
  `first_name` varchar(255) default NULL,
  `middle_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `fax_number` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_users_on_login` (`login`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `workgroup_addresses` (
  `id` varchar(36) NOT NULL,
  `workgroup_id` varchar(36) NOT NULL,
  `address_id` varchar(36) NOT NULL,
  `address_type_id` varchar(36) NOT NULL,
  `deleted_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `workgroup_logos` (
  `id` varchar(36) NOT NULL,
  `workgroup_id` varchar(36) NOT NULL,
  `path` varchar(255) NOT NULL,
  `height` int(11) default NULL,
  `width` int(11) default NULL,
  `deleted_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `workgroup_states` (
  `id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `workgroup_subtypes` (
  `id` varchar(36) NOT NULL,
  `workgroup_type_id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `workgroup_types` (
  `id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `workgroup_users` (
  `id` varchar(36) NOT NULL,
  `workgroup_id` varchar(36) NOT NULL,
  `user_id` varchar(36) NOT NULL,
  `deleted_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `workgroups` (
  `id` varchar(36) NOT NULL,
  `workgroup_subtype_id` varchar(36) NOT NULL,
  `workgroup_state_id` varchar(36) NOT NULL,
  `workgroup_type_id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `subdomain` varchar(255) NOT NULL,
  `office_number` varchar(255) NOT NULL,
  `fax_number` varchar(255) NOT NULL,
  `deleted_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `anyone_can_sign_referral_flag` tinyint(1) default '1',
  `subscriber_flag` tinyint(1) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `schema_info` (version) VALUES (114)