import 'stage_data.dart';
import 'stage2_data.dart';
import 'stage3_data.dart';
import 'stage4_data.dart';
import 'stage5_data.dart';

final allStages = <StageData>[stage1, stage2, stage3, stage4, stage5];

StageData stageById(int id) => allStages.firstWhere((s) => s.id == id);
