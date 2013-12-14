import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.prototype.Circle;
import com.haxepunk.HXP;
import flash.geom.Point;
 
class Contestant extends Entity
{
	static var weaponWidth = 24;
	static var weaponHeight = 6;
	static var swingArc = 130;
    static var stunnedDuration = 0.2;
    static var hitAngleIncrement = 45;

    public function new(x:Float, y:Float, speed:Float)
    {
        super(x, y);
        this.speed = speed;
        width = 32;
        swingDuration = 0.2;
        weaponRange = 16 + weaponWidth;
        weaponStrength = 10;
        height = width;
        var halfWidth = Math.floor(halfWidth);
        var sprite = Image.createCircle(halfWidth, 0xFF0000);
        addGraphic(sprite);
        weapon = Image.createRect(weaponWidth, weaponHeight, 0x00FF00);
        weapon.centerOrigin();
        weapon.originX = weaponWidth;
        addGraphic(weapon);
        weapon.visible = false;
        moveDir = new Point();
        dir = new Point(1, 0);
        sprite.centerOrigin();
        var circleMask = new com.haxepunk.masks.Circle(halfWidth, -halfWidth, -halfWidth);
        mask = circleMask;
        centerOrigin();
        type = "contestant";
    }

    public function setMoveDirection(dX:Int, dY:Int)
    {
        if (stunnedCooldown > 0)
            return;

    	moveDir.x = dX;
    	moveDir.y = dY;
    	moveDir.normalize(speed);
    }

    public function setAimDirection(dX:Int, dY:Int)
    {
        if (!weapon.visible && (dX != 0 || dY != 0))
        {
            dir.x = dX;
            dir.y = dY;
            dir.normalize(1);
        }        
    }

    public function swing()
    {
        if (weapon.visible || stunnedCooldown > 0)
        {
            return;
        }

    	swingCooldown = swingDuration;
    	weapon.visible = true;
        updateWeaponAngle();
    }

    public function receiveSwing(angle:Float, strength:Float)
    {
        if (stunnedCooldown > 0)
            return;

        hitDir = new Point();
        HXP.angleXY(hitDir, angle, strength);
        stunnedCooldown = stunnedDuration;
        weapon.visible = false;
        moveDir = new Point();
    }

    function updateWeaponAngle()
    {
        var angle = HXP.angle(0, 0, dir.x, dir.y);
        var halfSwingArc = swingArc / 2;
        weapon.angle = (angle - halfSwingArc) + swingArc * (1 - swingCooldown / swingDuration);
        HXP.angleXY(weapon, weapon.angle, weaponRange);

        var colliders = new Array<Entity>();
        scene.collidePointInto(type, x + weapon.x, y + weapon.y, colliders);
        for (e in colliders) {
            if (e == this)
                continue;
            var hitAngle = weapon.angle + hitAngleIncrement;
            var contestant = cast(e, Contestant);
            contestant.receiveSwing(hitAngle, weaponStrength);
        }
    }

    public override function update()
    {
    	super.update();
    	moveBy(moveDir.x, moveDir.y, type);
    	if (weapon.visible)
    	{
    		swingCooldown -= HXP.elapsed;
            updateWeaponAngle();
    		if (swingCooldown < 0)
    		{
    			weapon.visible = false;
    		}
    	}
        if (stunnedCooldown > 0)
        {
            stunnedCooldown -= HXP.elapsed;
            moveBy(hitDir.x, hitDir.y, type);
        }
    }

    var moveDir:Point;
    var dir:Point;
    var speed:Float;
    var weapon:Image;
    var swingDuration:Float;
    var swingCooldown:Float;
    var weaponRange:Float;
    var weaponStrength:Float;
    
    var hitDir:Point;
    var stunnedCooldown:Float;
}