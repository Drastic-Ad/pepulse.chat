import 'package:camera/camera.dart';
import 'package:get/get.dart';
export 'package:get/get.dart';
import 'controllers/common_controllers/app_controller.dart';
import 'controllers/common_controllers/firebase_common_controller.dart';
export 'package:flutter/material.dart';
export 'package:chatzy/packages_list.dart';
export '../controllers/index.dart';
export '../common/extension/text_style_extensions.dart';
export '../common/theme/index.dart';
export '../routes/screen_list.dart';
export '../routes/route_name.dart';
export '../common/assets/index.dart';
export '../common/extension/spacing.dart';
export '../common/extension/widget_extension.dart';
export '../widgets/dotted_line.dart';
export '../utils/extensions.dart';
export '../widgets/button_common.dart';
export '../widgets/text_field_common.dart';
export '../utils/alert_utils.dart';
export '../widgets/alert_message_common.dart';
export '../routes/index.dart';
export '../widgets/action_icon_common.dart';
export '../widgets/tab_bar_decoration.dart';
export '../utils/story_dotted_lines.dart';
export '../widgets/popup_menu_common.dart';
export '../widgets/popup_menu_item_common.dart';
export '../models/chat_model.dart';
export '../models/contact_model.dart';
export '../models/firebase_contact_model.dart';
export '../utils/general_utils.dart';
export '../utils/type_list.dart';
export '../widgets/emoji_layout.dart';
export '../screens/app_screens/chat_message/layouts/receiver/receiver_content.dart';
export '../screens/app_screens/chat_message/layouts/receiver/receiver_image.dart';
export '../widgets/reaction_pop_up/reaction_config.dart';
export '../widgets/reaction_pop_up/reaction_pop_up.dart';
export '../../../../../models/message_model.dart';
export '../widgets/directionality_rtl.dart';
export 'package:chatzy/screens/app_screens/pick_up_call/pick_up_call.dart';

final appCtrl = Get.isRegistered<AppController>()
    ? Get.find<AppController>()
    : Get.put(AppController());

final firebaseCtrl = Get.isRegistered<FirebaseCommonController>()
    ? Get.find<FirebaseCommonController>()
    : Get.put(FirebaseCommonController());


List<CameraDescription> cameras = [];