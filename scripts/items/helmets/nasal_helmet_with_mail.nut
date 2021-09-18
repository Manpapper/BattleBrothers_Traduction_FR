this.nasal_helmet_with_mail <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.nasal_helmet_with_mail";
		this.m.Name = "Nasal Helmet with Mail";
		this.m.Description = "A metal helmet with added noseguard and a mail coif underneath.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		local variants = [
			3,
			3,
			3,
			3,
			3,
			3,
			3,
			96,
			97,
			98,
			99,
			170
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 1250;
		this.m.Condition = 200;
		this.m.ConditionMax = 200;
		this.m.StaminaModifier = -12;
		this.m.Vision = -2;
	}

	function setPlainVariant()
	{
		this.setVariant(3);
	}

	function onPaint( _color )
	{
		switch(_color)
		{
		case this.Const.Items.Paint.None:
			this.m.Variant = 3;
			break;

		case this.Const.Items.Paint.Black:
			this.m.Variant = 99;
			break;

		case this.Const.Items.Paint.WhiteBlue:
			this.m.Variant = 96;
			break;

		case this.Const.Items.Paint.WhiteGreenYellow:
			this.m.Variant = 97;
			break;

		case this.Const.Items.Paint.OrangeRed:
			this.m.Variant = 98;
			break;

		case this.Const.Items.Paint.Red:
			this.m.Variant = 170;
			break;
		}

		this.updateVariant();
		this.updateAppearance();
	}

});

