pub const method = enum {
    sendMessage,
    getUpdates,
};

pub const Update = struct {
    // This object represents an incoming update.
    // At most one of the optional parameters can be present in any given update.
    //
    // The update's unique identifier. Update identifiers start from a certain
    // positive number and increase sequentially. This identifier becomes
    // especially handy if you're using webhooks, since it allows you to ignore
    // repeated updates or to restore the correct update sequence, should they
    // get out of order. If there are no new updates for at least a week, then
    // identifier of the next update will be chosen randomly instead of
    // sequentially.
    update_id: i64,
    //
    // Optional. New incoming message of any kind - text, photo, sticker, etc.
    message: ?Message,
    //
    // Optional. New version of a message that is known to the bot and was
    // edited. This update may at times be triggered by changes to message
    // fields that are either unavailable or not actively used by your bot.
    // edited_message: ?Message,
    //
    // Optional. New incoming channel post of any kind - text, photo,
    // sticker, etc.
    // channel_post: ?Message,
    //
    // Optional. New version of a channel post that is known to the bot and was
    // edited. This update may at times be triggered by changes to message
    // fields that are either unavailable or not actively used by your bot.
    // edited_channel_post: ?Message,
    //
    // Optional. The bot was connected to or disconnected from a business
    // account, or a user edited an existing connection with the bot
    // business_connection: ?BusinessConnection,
    // Optional. New message from a connected business account
    // business_message: ?Message,
    //
    // Optional. New version of a message from a connected business account
    // edited_business_message: ?Message,
    //
    // Optional. Messages were deleted from a connected business account
    // deleted_business_messages: ?BusinessMessagesDeleted,
    //
    // Optional. A reaction to a message was changed by a user. The bot must be
    // an administrator in the chat and must explicitly specify
    // "message_reaction" in the list of allowed_updates to receive these
    // updates. The update isn't received for reactions set by bots.
    // message_reaction: ?MessageReactionUpdated,
    //
    // Optional. Reactions to a message with anonymous reactions were changed.
    // The bot must be an administrator in the chat and must explicitly specify
    // "message_reaction_count" in the list of allowed_updates to receive these
    // updates. The updates are grouped and can be sent with delay up to a few
    // minutes.
    // message_reaction_count: ?MessageReactionCountUpdated,
    //
    // Optional. New incoming inline query
    // inline_query: ?InlineQuery,
    //
    // Optional. The result of an inline query that was chosen by a user and
    // sent to their chat partner. Please see our documentation on the feedback
    // collecting for details on how to enable these updates for your bot.
    // chosen_inline_result: ?ChosenInlineResult,
    //
    // Optional. New incoming callback query
    // callback_query: ?CallbackQuery,
    //
    // Optional. New incoming shipping query. Only for invoices with flexible
    // price
    // shipping_query: ?ShippingQuery,
    //
    // Optional. New incoming pre-checkout query. Contains full information
    // about checkout
    // pre_checkout_query: ?PreCheckoutQuery,
    //
    // Optional. A user purchased paid media with a non-empty payload sent by
    // the bot in a non-channel chat
    // purchased_paid_media: ?PaidMediaPurchased,
    //
    // Optional. New poll state. Bots receive only updates about manually
    // stopped polls and polls, which are sent by the bot
    // poll: ?Poll,
    //
    // Optional. A user changed their answer in a non-anonymous poll. Bots
    // receive new votes only in polls that were sent by the bot itself.
    // poll_answer: ?PollAnswer,
    //
    // Optional. The bot's chat member status was updated in a chat. For
    // private chats, this update is received only when the bot is blocked or
    // unblocked by the user.
    // my_chat_member: ?ChatMemberUpdated,
    //
    // Optional. A chat member's status was updated in a chat. The bot must be
    // an administrator in the chat and must explicitly specify "chat_member"
    // in the list of allowed_updates to receive these updates.
    // chat_member: ?ChatMemberUpdated,
    //
    // Optional. A request to join the chat has been sent. The bot must have
    // the can_invite_users administrator right in the chat to receive these
    // updates.
    // chat_join_request: ?ChatJoinRequest,
    //
    // Optional. A chat boost was added or changed. The bot must be an
    // administrator in the chat to receive these updates.
    // chat_boost: ?ChatBoostUpdated,
    //
    // Optional. A boost was removed from a chat. The bot must be an
    // administrator in the chat to receive these updates.
    // removed_chat_boost: ?ChatBoostRemoved,
};

pub const emptyUpdate = Update{ .update_id = 0, .message = Message{ .message_id = 0, .date = 0, .text = null } };

// All types used in the Bot API responses are represented as JSON-objects.
// It is safe to use 32-bit signed integers for storing all Integer fields unless otherwise noted.
// Optional fields may be not returned when irrelevant.

pub const User = struct {
    // This object represents a Telegram user or bot.

    // Unique identifier for this user or bot.
    // This number may have more than 32 significant bits and some programming languages may have difficulty/silent defects in interpreting it.
    // But it has at most 52 significant bits, so a 64-bit integer or double-precision float type are safe for storing this identifier.
    id: i64,
    //
    // True, if this user is a bot
    is_bot: bool,
    //
    // User's or bot's first name
    first_name: []const u8,
    //
    // Optional. User's or bot's last name
    // last_name: ?[]const u8,
    //
    // Optional. User's or bot's username
    username: ?[]const u8,
    //
    // Optional. IETF language tag of the user's language
    // language_code: ?[]const u8,
    //
    // Optional. True, if this user is a Telegram Premium user
    // is_premium: ?bool,
    //
    // Optional. True, if this user added the bot to the attachment menu
    // added_to_attachment_menu: ?bool,
    //
    // Optional. True, if the bot can be invited to groups. Returned only in getMe.
    // can_join_groups: ?bool,
    //
    // Optional. True, if privacy mode is disabled for the bot. Returned only in getMe.
    // can_read_all_group_messages: ?bool,
    //
    // Optional. True, if the bot supports inline queries. Returned only in getMe.
    // supports_inline_queries: ?bool,
    //
    // Optional. True, if the bot can be connected to a Telegram Business account to receive its messages. Returned only in getMe.
    // can_connect_to_business: ?bool,
    //
    // Optional. True, if the bot has a main Web App. Returned only in getMe.
    // has_main_web_app: ?bool,
};

pub const ChatType = enum {
    private,
    group,
    supergroup,
    channel,
};

pub const Chat = struct {
    // This object represents a chat.
    //
    // Unique identifier for this chat. This number may have more than 32
    // significant bits and some programming languages may have difficulty/silent
    // defects in interpreting it. But it has at most 52 significant bits, so a
    // signed 64-bit integer or double-precision float type are safe for storing
    // this identifier.
    id: i64,
    //
    // Type of the chat, can be either “private”, “group”, “supergroup” or “channel”
    type: ChatType,
    //
    // Optional. Title, for supergroups, channels and group chats
    // title: ?[]const u8,
    //
    // Optional. Username, for private chats, supergroups and channels if available
    // username: ?[]const u8,
    //
    // Optional. First name of the other party in a private chat
    // first_name: ?[]const u8,
    //
    // Optional. Last name of the other party in a private chat
    // last_name: ?[]const u8,
    //
    // Optional. True, if the supergroup chat is a forum (has topics enabled)
    // is_forum: ?bool,
};

pub const Message = struct {
    // This object represents a message.
    //
    // Unique message identifier inside this chat. In specific instances (e.g., message containing a video sent to a big chat), the server might automatically schedule a message instead of sending it immediately. In such cases, this field will be 0 and the relevant message will be unusable until it is actually sent
    message_id: i64,
    //
    // Optional. Unique identifier of a message thread to which the message belongs; for supergroups only
    // message_thread_id: ?i64,
    //
    // Optional. Sender of the message; may be empty for messages sent to channels. For backward compatibility, if the message was sent on behalf of a chat, the field contains a fake sender user in non-channel chats
    // from: ?User,
    //
    // Optional. Sender of the message when sent on behalf of a chat. For example, the supergroup itself for messages sent by its anonymous administrators or a linked channel for messages automatically forwarded to the channel's discussion group. For backward compatibility, if the message was sent on behalf of a chat, the field from contains a fake sender user in non-channel chats.
    // sender_chat: ?Chat,
    //
    // Optional. If the sender of the message boosted the chat, the number of boosts added by the user
    // sender_boost_count: ?i64,
    //
    // Optional. The bot that actually sent the message on behalf of the business account. Available only for outgoing messages sent on behalf of the connected business account.
    // sender_business_bot: ?User,
    //
    // Date the message was sent in Unix time. It is always a positive number, representing a valid date.
    date: i64,
    //
    // Optional. Unique identifier of the business connection from which the message was received. If non-empty, the message belongs to a chat of the corresponding business account that is independent from any potential bot chat which might share the same identifier.
    // business_connection_id: ?[]const u8,
    //
    // Chat the message belongs to
    // chat: Chat,
    //
    // Optional. Information about the original message for forwarded messages
    // forward_origin: ?MessageOrigin,
    //
    // Optional. True, if the message is sent to a forum topic
    // is_topic_message: ?bool,
    //
    // Optional. True, if the message is a channel post that was automatically forwarded to the connected discussion group
    // is_automatic_forward: ?bool,
    //
    // Optional. For replies in the same chat and message thread, the original message. Note that the Message object in this field will not contain further reply_to_message fields even if it itself is a reply.
    // reply_to_message: ?*Message,
    //
    // Optional. Information about the message that is being replied to, which may come from another chat or forum topic
    // external_reply: ?ExternalReplyInfo,
    //
    // Optional. For replies that quote part of the original message, the quoted part of the message
    // quote: ?TextQuote,
    //
    // Optional. For replies to a story, the original story
    // reply_to_story: ?Story,
    //
    // Optional. For replies to a story, the original story
    // via_bot: ?User,
    //
    // Optional. Date the message was last edited in Unix time
    // edit_date: ?i64,
    //
    // Optional. True, if the message can't be forwarded
    // has_protected_content: ?bool,
    //
    // Optional. True, if the message was sent by an implicit action, for example, as an away or a greeting business message, or as a scheduled message
    // is_from_offline: ?bool,
    //
    // Optional. The unique identifier of a media message group this message belongs to
    // media_group_id: ?[]const u8,
    //
    // Optional. Signature of the post author for messages in channels, or the custom title of an anonymous group administrator
    // author_signature: ?[]const u8,
    //
    // Optional. For text messages, the actual UTF-8 text of the message
    text: ?[]const u8,
    //
    // Optional. For text messages, special entities like usernames, URLs, bot commands, etc. that appear in the text
    // entities: ?[]MessageEntity,
    //
    // Optional. Options used for link preview generation for the message, if it is a text message and link preview options were changed
    // link_preview_options: ?LinkPreviewOptions,
    //
    // Optional. Unique identifier of the message effect added to the message
    // effect_id: ?[]const u8,
    //
    // Optional. Message is an animation, information about the animation. For backward compatibility, when this field is set, the document field will also be set
    // animation: ?Animation,
    //
    // Optional. Message is an audio file, information about the file
    // audio: ?Audio,
    //
    // Optional. Message is a general file, information about the file
    // document: ?Document,
    //
    // Optional. Message contains paid media; information about the paid media
    // paid_media: ?PaidMediaInfo,
    //
    // Optional. Message is a photo, available sizes of the photo
    // photo: ?[]PhotoSize,
    //
    // Optional. Message is a sticker, information about the sticker
    // sticker: ?Sticker,
    //
    // Optional. Message is a forwarded story
    // story: ?Story,
    //
    // Optional. Message is a video, information about the video
    // video: ?Video,
    //
    // Optional. Message is a video note, information about the video message
    // video_note: ?VideoNote,
    //
    // Optional. Message is a voice message, information about the file
    // voice: ?Voice,
    //
    // Optional. Caption for the animation, audio, document, paid media, photo, video or voice
    // caption: ?[]const u8,
    //
    // Optional. For messages with a caption, special entities like usernames, URLs, bot commands, etc. that appear in the caption
    // caption_entities: ?[]MessageEntity,
    //
    // Optional. True, if the caption must be shown above the message media
    // show_caption_above_media: ?bool,
    //
    // Optional. True, if the message media is covered by a spoiler animation
    // has_media_spoiler: ?bool,
    //
    // Optional. Message is a shared contact, information about the contact
    // contact: ?Contact,
    //
    // Optional. Message is a dice with random value
    // dice: ?Dice,
    //
    // Optional. Message is a game, information about the game. More about games »
    // game: ?Game,
    //
    // Optional. Message is a native poll, information about the poll
    // poll: ?Poll,
    //
    // Optional. Message is a venue, information about the venue. For backward compatibility, when this field is set, the location field will also be set
    // venue: ?Venue,
    //
    // Optional. Message is a shared location, information about the location
    // location: ?Location,
    //
    // Optional. New members that were added to the group or supergroup and information about them (the bot itself may be one of these members)
    // new_chat_members: ?[]User,
    //
    // Optional. A member was removed from the group, information about them (this member may be the bot itself)
    // left_chat_member: ?User,
    //
    // Optional. A chat title was changed to this value
    // new_chat_title: ?[]const u8,
    //
    // Optional. A chat photo was change to this value
    // new_chat_photo: ?[]PhotoSize,
    //
    // Optional. Service message: the chat photo was deleted
    // delete_chat_photo: ?bool,
    //
    // Optional. Service message: the group has been created
    // group_chat_created: ?bool,
    //
    // Optional. Service message: the supergroup has been created. This field can't be received in a message coming through updates, because bot can't be a member of a supergroup when it is created. It can only be found in reply_to_message if someone replies to a very first message in a directly created supergroup.
    // supergroup_chat_created: ?bool,
    //
    // Optional. Service message: the channel has been created. This field can't be received in a message coming through updates, because bot can't be a member of a channel when it is created. It can only be found in reply_to_message if someone replies to a very first message in a channel.
    // channel_chat_created: ?bool,
    //
    // Optional. Service message: auto-delete timer settings changed in the chat
    // message_auto_delete_timer_changed: ?MessageAutoDeleteTimerChanged,
    //
    // Optional. The group has been migrated to a supergroup with the specified identifier. This number may have more than 32 significant bits and some programming languages may have difficulty/silent defects in interpreting it. But it has at most 52 significant bits, so a signed 64-bit integer or double-precision float type are safe for storing this identifier.
    // migrate_to_chat_id: ?i64,
    //
    // Optional. The supergroup has been migrated from a group with the specified identifier. This number may have more than 32 significant bits and some programming languages may have difficulty/silent defects in interpreting it. But it has at most 52 significant bits, so a signed 64-bit integer or double-precision float type are safe for storing this identifier.
    // migrate_from_chat_id: ?i64,
    //
    // Optional. Specified message was pinned. Note that the Message object in this field will not contain further reply_to_message fields even if it itself is a reply.
    // pinned_message: ?MaybeInaccessibleMessage,
    //
    // Optional. Message is an invoice for a payment, information about the invoice.
    // invoice: ?Invoice,
    //
    // Optional. Message is a service message about a successful payment, information about the payment.
    // successful_payment: ?SuccessfulPayment,
    //
    // Optional. Message is a service message about a refunded payment, information about the payment.
    // refunded_payment: ?RefundedPayment,
    //
    // Optional. Service message: users were shared with the bot
    // users_shared: ?UsersShared,
    //
    // Optional. Service message: a chat was shared with the bot
    // chat_shared: ?ChatShared,
    //
    // Optional. The domain name of the website on which the user has logged in.
    // connected_website: ?[]const u8,
    //
    // Optional. Service message: the user allowed the bot to write messages after adding it to the attachment or side menu, launching a Web App from a link, or accepting an explicit request from a Web App sent by the method requestWriteAccess
    // write_access_allowed: ?WriteAccessAllowed,
    //
    // Optional. Telegram Passport data
    // passport_data: ?PassportData,
    //
    // Optional. Service message. A user in the chat triggered another user's proximity alert while sharing Live Location.
    // proximity_alert_triggered: ?ProximityAlertTriggered,
    //
    // Optional. Service message: user boosted the chat
    // boost_added: ?ChatBoostAdded,
    //
    // Optional. Service message: chat background set
    // chat_background_set: ?ChatBackground,
    //
    // Optional. Service message: forum topic created
    // forum_topic_created: ?ForumTopicCreated,
    //
    // Optional. Service message: forum topic edited
    // forum_topic_edited: ?ForumTopicEdited,
    //
    // Optional. Service message: forum topic closed
    // forum_topic_closed: ?ForumTopicClosed,
    //
    // Optional. Service message: forum topic reopened
    // forum_topic_reopened: ?ForumTopicReopened,
    //
    // Optional. Service message: the 'General' forum topic hidden
    // general_forum_topic_hidden: ?GeneralForumTopicHidden,
    //
    // Optional. Service message: the 'General' forum topic unhidden
    // general_forum_topic_unhidden: ?GeneralForumTopicUnhidden,
    //
    // Optional. Service message: a scheduled giveaway was created
    // giveaway_created: ?GiveawayCreated,
    //
    // Optional. The message is a scheduled giveaway message
    // giveaway: ?Giveaway,
    //
    // Optional. A giveaway with public winners was completed
    // giveaway_winners: ?GiveawayWinners,
    //
    // Optional. Service message: a giveaway without public winners was completed
    // giveaway_completed: ?GiveawayCompleted,
    //
    // Optional. Service message: video chat scheduled
    // video_chat_scheduled: ?VideoChatScheduled,
    //
    // Optional. Service message: video chat started
    // video_chat_started: ?VideoChatStarted,
    //
    // Optional. Service message: video chat ended
    // video_chat_ended: ?VideoChatEnded,
    //
    // Optional. Service message: new participants invited to a video chat
    // video_chat_participants_invited: ?VideoChatParticipantsInvited,
    //
    // Optional. Service message: data sent by a Web App
    // web_app_data: ?WebAppData,
    //
    // Optional. Service message: data sent by a Web App
    // reply_markup: ?InlineKeyboardMarkup,
};
