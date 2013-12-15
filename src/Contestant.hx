import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.prototype.Circle;
import com.haxepunk.HXP;
import flash.geom.Point;
 
class Contestant extends Entity
{
	static var weaponWidth = 12;
	static var weaponHeight = 3;
	static var swingArc = 130;
    static var stunnedDuration = 0.1;
    static var hitAngleIncrement = 45;

    public function new(x:Float, y:Float, speed:Float, swingDuration:Float)
    {
        super(x, y);
        this.speed = speed;
        width = 16;
        this.swingDuration = swingDuration;
        weaponRange = Math.floor(width / 2) + weaponWidth;
        weaponStrength = 6;
        var weaponImage = Image.createRect(weaponWidth, weaponHeight, 0x00FF00);
        installWeapon(weaponImage, weaponRange, weaponStrength);
        throwStrengthMultiplier = 1.5;
        throwSpeed = this.speed * 2;
        height = width;
        var halfWidth = Math.floor(halfWidth);
        sprite = Image.createCircle(halfWidth, 0xFF0000);
        addGraphic(sprite);
        moveDir = new Point();
        dir = new Point(1, 0);
        sprite.centerOrigin();
        var circleMask = new com.haxepunk.masks.Circle(halfWidth, -halfWidth, -halfWidth);
        mask = circleMask;
        centerOrigin();
        type = "contestant";
        layer = 50;
    }

    function installWeapon(image:Image, range:Float, strength:Float)
    {
        weapon = image;
        weaponRange = range;
        weaponStrength = strength;

        weapon.centerOrigin();
        weapon.originX = weaponWidth;
        addGraphic(weapon);
        weapon.visible = false;
    }

    function weaponIdle()
    {
        return !(weapon == null || weapon.visible || stunnedCooldown > 0);
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
        if ((weapon == null || !weapon.visible) && (dX != 0 || dY != 0))
        {
            dir.x = dX;
            dir.y = dY;
            dir.normalize(1);
        }        
    }

    public function swing()
    {
        if (!weaponIdle())
        {
            return;
        }

    	swingCooldown = swingDuration;
    	weapon.visible = true;
        updateWeaponAngle();
    }

    public function throw_()
    {
        if (!weaponIdle())
            return;

        graphic = sprite;
        var weapon = new Weapon(x, y, dir.x, dir.y, throwSpeed, weapon, weaponRange, weaponStrength, weaponStrength * throwStrengthMultiplier, this);
        scene.add(weapon);
        this.weapon = null;
    }

    public function receiveSwing(angle:Float, strength:Float)
    {
        if (stunnedCooldown > 0)
            return;

        hitDir = new Point();
        HXP.angleXY(hitDir, angle, strength);
        stunnedCooldown = stunnedDuration;
        if (weapon != null)
        {
            weapon.visible = false;
        }
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
    	if (weapon != null && weapon.visible)
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
        if (weapon == null)
        {
            var weapons = new Array<Entity>();
            this.collideInto("weapon", x, y, weapons);
            for (e in weapons)
            {
                var weapon = cast(e, Weapon);
                if (weapon.dangerous)
                {
                    continue;
                }

                weapon.pickup();
                installWeapon(weapon.image, weapon.range, weapon.strength);
            }
        }
    }

    var sprite:Image;
    var moveDir:Point;
    var dir:Point;
    var speed:Float;
    var throwSpeed:Float;
    var throwStrengthMultiplier:Float;
    var swingDuration:Float;
    var swingCooldown:Float;
    var weapon:Image;
    var weaponRange:Float;
    var weaponStrength:Float;
    
    var hitDir:Point;
    var stunnedCooldown:Float;
}