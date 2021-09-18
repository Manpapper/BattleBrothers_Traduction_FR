this.bascinet_with_mail <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.bascinet_with_mail";
		this.m.Name = "Bascinet with Mail";
		this.m.Description = "A metal bascinet worn atop a thick mail coif.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		local variants = [
			54,
			54,
			54,
			54,
			54,
			54,
			54,
			154,
			155,
			156,
			157,
			186
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 1400;
		this.m.Condition = 210;
		this.m.ConditionMax = 210;
		this.m.StaminaModifier = -13;
		this.m.Vision = -2;
	}

	function onPaint( _color )
	{
		switch(_color)
		{
		case this.Const.Items.Paint.None:
			this.m.Variant = 54;
			break;

		case this.Const.Items.Paint.Black:
			this.m.Variant = 154;
			break;

		case this.Const.Items.Paint.WhiteBlue:
			this.m.Variant = 157;
			break;

		case this.Const.Items.Paint.WhiteGreenYellow:
			this.m.Variant = 156;
			break;

		case this.Const.Items.Paint.OrangeRed:
			this.m.Variant = 155;
			break;

		case this.Const.Items.Paint.Red:
			this.m.Variant = 186;
			break;
		}

		this.updateVariant();
		this.updateAppearance();
	}

});

