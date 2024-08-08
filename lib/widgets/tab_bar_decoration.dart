import '../../../config.dart';
import 'material_indicator.dart';

//indicator

MaterialIndicator materialIndicator() =>  MaterialIndicator(
    height: 5,
    strokeWidth: 3,
    color: appCtrl.appTheme.primary,
    horizontalPadding: Insets.i15,
    tabPosition: TabPosition.bottom);
