import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.prototype.Circle;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;
import com.haxepunk.tweens.misc.NumTween;
import com.haxepunk.utils.Ease;
import flash.geom.Point;
import flash.geom.Rectangle;
 
class Contestant extends Entity
{
	static var weaponWidth = 24;
	static var weaponHeight = 3;
	static var swingArc = 130;
    static var stunnedDuration = 0.1;
    static var hitAngleIncrement = 45;
    static var bounceSpeed = 0.075;

    function bounceArc(progress:Float)
    {
        var x = (progress * 2) - 1;
        return (x * x) * 5;
    }

    public function new(x:Float, y:Float, speed:Float, swingDuration:Float, arena:Arena, color:Int, strength:Float)
    {
        super(x, y);
        this.speed = speed;
        width = 16;
        height = 8;
        this.swingDuration = swingDuration;
        weaponRange = Math.floor(width / 2) + weaponWidth;
        weaponStrength = strength;
        var weaponImage = new Image("graphics/paddle.png");
        installWeapon(weaponImage, weaponRange, weaponStrength);
        throwStrengthMultiplier = 1.5;
        throwSpeed = this.speed * 2;

        sprite = new Graphiclist();
        var base = new Image("graphics/player.png", new Rectangle(0,48,16,24));
        base.color = color;
        base.centerOrigin();
        base.originY = 24;
        sprite.add(base);

        eyes = new Spritemap("graphics/player.png", 16, 24);
        eyes.add("down_squint", [0]);
        eyes.add("up_squint", [0]);
        eyes.add("left_squint", [0]);
        eyes.add("right_squint", [0]);
        eyes.add("down", [4]);
        eyes.add("up", [5]);
        eyes.add("left", [6]);
        eyes.add("right", [7]);
        eyes.originX = base.originX;
        eyes.originY = base.originY;
        sprite.add(eyes);

        shadow = new Image("graphics/player.png", new Rectangle(16,48,16,24));
        shadow.originX = 8;
        shadow.originY = 19;
        shadow.alpha = 0.5;
        addGraphic(shadow);
        addGraphic(sprite);

        moveDir = new Point();
        dir = new Point(1, 0);
        centerOrigin();
        this.arena = arena;
        type = "contestant";

        hitSfx = new Array<Sfx>();
        hitSfx.push(new Sfx("audio/hit_1.wav"));
        hitSfx.push(new Sfx("audio/hit_2.wav"));
        hitSfx.push(new Sfx("audio/hit_3.wav"));

        fallSfx = new Sfx("audio/fall.wav");
        dropTween = new NumTween();
        addTween(dropTween);
        dropTween.tween(240, 0, 2, Ease.bounceOut);
        falling = true;
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
        if (stunnedCooldown > 0 || falling)
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
            var angle = HXP.angle(0,0,dX,dY);
            var animation = "";
            if (angle > 135 && angle < 225)
            {
                animation = "left";
            }
            else if (angle < 45 || angle > 315)
            {
                animation = "right";
            }
            else if (angle > 45 && angle < 135)
            {
                animation = "up";
            }
            else if (angle > 225 && angle < 315)
            {
                animation = "down";
            }

            if (stunnedCooldown > 0)
            {
                animation += "_squint";
            }

            eyes.play(animation);
        }        
    }

    public function swing()
    {
        if (!weaponIdle() || falling)
        {
            return;
        }

    	swingCooldown = swingDuration;
    	weapon.visible = true;
        updateWeaponAngle();
    }

    public function throw_()
    {
        if (!weaponIdle() || falling)
            return;

        graphic = new Graphiclist();
        addGraphic(shadow);
        addGraphic(sprite);
        var weapon = new Weapon(x, y, dir.x, dir.y, throwSpeed, weapon, weaponRange, weaponStrength, weaponStrength * throwStrengthMultiplier, this);
        scene.add(weapon);
        this.weapon = null;
    }

    public function receiveSwing(angle:Float, strength:Float)
    {
        if (stunnedCooldown > 0 || falling)
            return;

        hitDir = new Point();
        HXP.angleXY(hitDir, angle, strength);
        stunnedCooldown = stunnedDuration;
        if (weapon != null)
        {
            weapon.visible = false;
        }
        moveDir = new Point();
        if (wasHit != null) wasHit();
        hitSfx[HXP.rand(hitSfx.length)].play();
    }

    function updateWeaponAngle()
    {
        var angle = HXP.angle(0, 0, dir.x, dir.y);
        var halfSwingArc = swingArc / 2;
        weapon.angle = (angle - halfSwingArc) + swingArc * (1 - swingCooldown / swingDuration);
        HXP.angleXY(weapon, weapon.angle, weaponRange);

        var colliders = new Array<Entity>();
        var steps = 3;
        for (i in 0...steps)
        {
            var incr = (i + 1) / steps;
            scene.collidePointInto(type, x + weapon.x * incr, y + weapon.y * incr, colliders);
            for (e in colliders) {
                if (e == this)
                    continue;
                var hitAngle = HXP.angle(x, y, e.x, e.y);
                var contestant = cast(e, Contestant);
                contestant.receiveSwing(hitAngle, weaponStrength);
            }
        }
    }

    public override function update()
    {
    	super.update();
        if (dropTween != null)
        {
            sprite.y = -dropTween.value;
            shadow.scale = 1 - dropTween.value / 240;
            if (!dropTween.active)
            {
                dropTween = null;
                falling = false;
            }
            return;
        }

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

        if (!falling)
        {
            layer = 50 - Math.floor(y / 240 * 12);
            if (bounceProgress < 1 && !(stunnedCooldown > 0))
            {
                bounceProgress += bounceSpeed;
            }
            else if (moveDir.x != 0 || moveDir.y != 0)
            {
                bounceProgress = 0;
            }
            else
            {
                bounceProgress = 1;
            }

            sprite.y = bounceArc(bounceProgress);
        }

        if (!falling && collideWith(arena, x, y) == null)
        {
            falling = true;
            type = "falling_contestant";
            moveDir.y = 2;
            if (arena.y > y)
            {
                layer = arena.layer + 1;
            }
            fallSfx.play();
        }
        else if (falling)
        {
            moveDir.y *= 1.05;
            if (x < -width || y < -height || x > 320 + width || y > 240 + height)
            {
                scene.remove(this);
                if (defeated != null)
                    defeated();
            }
        }
    }

    public var defeated:Void->Void;
    public var wasHit:Void->Void;

    var sprite:Graphiclist;
    var eyes:Spritemap;
    var shadow:Image;
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
    var arena:Arena;
    var falling:Bool;
    var bounceProgress:Float;
    var dropTween:NumTween;

    var hitSfx:Array<Sfx>;
    var fallSfx:Sfx;
    
    var hitDir:Point;
    var stunnedCooldown:Float;
}