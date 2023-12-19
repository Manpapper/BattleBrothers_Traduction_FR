this.arena_spectator <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Spectateur";
	}

	function getDescription()
	{
		return "Un spectateur acclamant le combat de l'arène";
	}

	function setFlipped( _flip )
	{
		this.getSprite("body").setHorizontalFlipping(_flip);
		this.getSprite("head").setHorizontalFlipping(_flip);
		this.getSprite("armor").setHorizontalFlipping(_flip);
		this.getSprite("beard").setHorizontalFlipping(_flip);
		this.getSprite("helmet").setHorizontalFlipping(_flip);
		this.getSprite("hair").setHorizontalFlipping(_flip);
		this.getSprite("beard_top").setHorizontalFlipping(_flip);
	}

	function onInit()
	{
		local body = this.addSprite("body");
		body.setBrush(this.Const.Bodies.SouthernMale[this.Math.rand(0, this.Const.Bodies.SouthernMale.len() - 1)]);
		body.varyColor(0.05, 0.05, 0.05);
		body.varySaturation(0.1);
		local armor = this.addSprite("armor");

		if (this.Math.rand(1, 100) <= 95)
		{
			local armors = [
				"bust_desert_noble_01",
				"bust_desert_noble_02",
				"bust_body_01",
				"bust_body_02",
				"bust_body_03",
				"bust_body_04",
				"bust_body_05",
				"bust_body_08",
				"bust_body_southern_03",
				"bust_body_southern_05",
				"bust_body_southern_06",
				"bust_body_southern_12",
				"bust_body_southern_12",
				"bust_body_southern_18",
				"bust_body_southern_19",
				"bust_body_southern_13",
				"bust_body_southern_14",
				"bust_body_southern_16",
				"bust_body_southern_17"
			];
			armor.setBrush(armors[this.Math.rand(0, armors.len() - 1)]);
		}

		local head = this.addSprite("head");
		head.setBrush(this.Const.Faces.SouthernMale[this.Math.rand(0, this.Const.Faces.SouthernMale.len() - 1)]);
		head.Color = body.Color;
		head.Saturation = body.Saturation;
		local beard = this.addSprite("beard");

		if (this.Math.rand(1, 100) <= 60)
		{
			beard.setBrush("beard_brown_" + this.Const.Beards.Southern[this.Math.rand(0, this.Const.Beards.Southern.len() - 1)]);
			beard.Saturation = 0.8;
			beard.setBrightness(0.4);
		}

		local hair = this.addSprite("hair");
		local helmet = this.addSprite("helmet");

		if (!beard.HasBrush)
		{
			local helmets = [
				"bust_helmet_southern_07",
				"bust_helmet_southern_08",
				"bust_helmet_southern_09",
				"bust_helmet_southern_12",
				"bust_helmet_southern_16",
				"bust_helmet_southern_18_damaged",
				"helmet_desert_noble_01",
				"helmet_desert_noble_02",
				"helmet_desert_noble_03"
			];
			helmet.setBrush(helmets[this.Math.rand(0, helmets.len() - 1)]);
		}
		else if (this.Math.rand(1, 100) <= 95)
		{
			hair.setBrush("hair_brown_" + this.Const.Hair.SouthernMale[this.Math.rand(0, this.Const.Hair.SouthernMale.len() - 1)]);
			hair.Saturation = 0.8;
			hair.setBrightness(0.4);
		}

		local beard_top = this.addSprite("beard_top");

		if (beard.HasBrush && this.doesBrushExist(beard.getBrush().Name + "_top"))
		{
			beard_top.setBrush(beard.getBrush().Name + "_top");
			beard_top.Saturation = 0.8;
			beard_top.setBrightness(0.4);
		}
	}

});

