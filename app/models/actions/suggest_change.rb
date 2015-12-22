module Actions
  class SuggestChange
    include Actions::Transactional
    attr_reader :moderated_object, :moderation_params, :additional_params, :suggesting_user, :suggested_change
    def initialize(moderated_object, suggesting_user, moderation_params, additional_params)
      @moderated_object = moderated_object
      @suggesting_user = suggesting_user
      @moderation_params = moderation_params
      @additional_params = additional_params
    end

    def execute
      moderated_object.assign_attributes(moderation_params)
      @suggested_change = moderated_object.suggest_change!(suggesting_user, additional_params)
      Event.create(
        action: 'change suggested',
        originating_user: suggesting_user,
        subject: moderated_object,
        state_params: suggested_change.state_params
      )
      suggested_change.subscribe_user(suggesting_user)
    rescue NoSuggestedChangesError => e
      errors << 'The suggested change was identical to the existing item'
    rescue ListMembersNotFoundError => e
      errors << 'One or more provided ids does not appear to be valid'
    end
  end
end