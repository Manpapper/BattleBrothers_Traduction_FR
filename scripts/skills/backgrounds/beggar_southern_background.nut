this.beggar_southern_background <- this.inherit("scripts/skills/backgrounds/beggar_background", {
	m = {},
	function create()
	{
		this.beggar_background.create();
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.SouthernUntidy;
		this.m.Bodies = this.Const.Bodies.SouthernSkinny;
		this.m.BeardChance = 90;
		this.m.Ethnicity = 1;
		this.m.Names = this.Const.Strings.SouthernNames;
	}

	function onBuildDescription()
	{
		return "{Après avoir tout perdu dans un incendie, après que son addiction au jeu ait pris le dessus, après avoir été accusé d\'un crime qu\'il n\'a pas commis, et après avoir dû tout payer à l\'agent pour ne pas se retrouver dans les oubliettes, Un homme sans talent et sans ambition | Après avoir été libéré d\'un donjon où il a passé d\'innombrables années enchaîné à un mur | Après avoir donné tous ses biens à une secte obscure promettant le salut de son âme éternelle | Un homme très intelligent jusqu\'à ce qu\'un brigand l\'assomme}, {%name% s\'est retrouvé à la rue, %name% a été forcé à la rue,} {mendier son pain, dépendre de la bonne volonté des autres, être battu et se résigner à son sort, dépenser le peu d\'argent qu\'il avait pour boire tout le temps, fouiller dans les poubelles des autres et fuir les hommes de loi, éviter les ruffians et les voyous pendant qu\'il mendiait des couronnes}. {Bien qu\'il semble sincèrement vouloir devenir mercenaire, il ne fait aucun doute que tout le temps passé dans la rue a privé %name% de ses meilleures années. | Les années ont passé et ont eu raison de sa santé à présent. | Une fois qu\'un homme comme %name% a passé quelques jours dans les rues, et encore moins quelques années, même le très dangereux métier de mercenaire semble être le plus vert des pâturages. | Seuls les dieux savent ce que %name% a fait pour survivre, mais c\'est un homme frêle qui se tient devant vous maintenant. | A votre vue, il se lève à bras ouverts pour vous embrasser, affirmant vous connaître depuis des années et de nombreuses aventures partagées, bien que votre nom lui échappe pour le moment.}";
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			local item = this.new("scripts/items/helmets/oriental/nomad_head_wrap");
			item.setVariant(16);
			items.equip(item);
		}
	}

});

