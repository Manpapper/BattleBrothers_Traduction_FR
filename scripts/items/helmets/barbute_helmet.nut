this.barbute_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.barbute_helmet";
		this.m.Name = "Barbute Helmet";
		this.m.Description = "A sturdy yet light barbute helmet, a design uncommon in these lands, made from especially light and durable steel.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		local variants = [
			158,
			158,
			158,
			158,
			158,
			158,
			158,
			159,
			160,
			161,
			162,
			184
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 2600;
		this.m.Condition = 190;
		this.m.ConditionMax = 190;
		this.m.StaminaModifier = -9;
		this.m.Vision = -2;
	}

	function setPlainVariant()
	{
		this.setVariant(1);
	}

	function onPaint( _color )
	{
		switch(_color)
		{
		case this.Const.Items.Paint.None:
			this.m.Variant = 158;
			break;

		case this.Const.Items.Paint.Black:
			this.m.Variant = 159;
			break;

		case this.Const.Items.Paint.WhiteBlue:
			this.m.Variant = 162;
			break;

		case this.Const.Items.Paint.WhiteGreenYellow:
			this.m.Variant = 161;
			break;

		case this.Const.Items.Paint.OrangeRed:
			this.m.Variant = 160;
			break;

		case this.Const.Items.Paint.Red:
			this.m.Variant = 184;
			break;
		}

		this.updateVariant();
		this.updateAppearance();
	}

});

