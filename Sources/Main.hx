// Auto-generated
package ;
class Main {
    public static inline var projectName = 'runner';
    public static inline var projectPackage = 'runner';
    public static function main() {
        iron.object.BoneAnimation.skinMaxBones = 8;
        iron.object.LightObject.cascadeCount = 4;
        iron.object.LightObject.cascadeSplitFactor = 0.800000011920929;
        armory.system.Starter.main(
            'Scene',
            0,
            false,
            true,
            false,
            1920,
            1080,
            1,
            false,
            armory.renderpath.RenderPathCreator.get
        );
    }
}
