this.bastard_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.bastard";
		this.m.Name = "Bâtard";
		this.m.Icon = "ui/backgrounds/background_37.png";
		this.m.BackgroundDescription = "Les bâtards ont souvent bénéficié d\'une formation en combat de mêlée.";
		this.m.GoodEnding = "{%name%, the bastard son of a familially inconsiderate nobleman, departed the %companyname% to try to carve out his own family lineage. The last you heard, he\'d managed to acquire himself a good plot of land and a modest stone castle rests on it. While successful, he still harbors resentment for his family. | A bastard son of a nobleman, %name% couldn\'t help but always have that lingering feeling he just didn\'t belong in this. world. But the %companyname% gave him a brotherhood to call family. As far as you know, he still fights with the company to this. day.}";
		this.m.BadEnding = "Bastards like %name% usually don\'t get far in this. world. They\'re too hated in the highborn world in which they live, and hated by the lowborn because they don\'t understand the politics that would make a bastard more common to them than any nobleman. Not long after you left the company, you got wind of %name%\'s passing. Apparently, a young and cruel lord took over his noble house and saw the bastard as a threat to his throne. Despite the bastard wanting nothing to do with that life anymore, it managed to catch up with him anyway. He was assassinated in a tavern bed, his throat cut as he slept.";
		this.m.HiringCost = 110;
		this.m.DailyCost = 14;
		this.m.Excluded = [
			"trait.teamplayer",
			"trait.ailing",
			"trait.clumsy",
			"trait.fat",
			"trait.tiny",
			"trait.hesitant",
			"trait.bleeder",
			"trait.dastard",
			"trait.asthmatic"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(1, 3);
		this.m.IsCombatBackground = true;
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
	}

	function onBuildDescription()
	{
		return "{%name% est né lors d\'une campagne militaire enflammée, loin de la maison de son père. | La mère de %name% venait d\'un pub de %randomtown%. Ce qui est étrange, car son père est un roi marié dans %village%. | Avec une femme maudite par une sorcière, le père de %name% se donna à une autre femme pour continuer la lignée. | Avec le roi absent si longtemps, la reine de mère de %name% ne pouvait guère résister aux tentations d\'un serviteur local. | %name% est né neuf mois après que des pillards aient pillé le château de ses parents.} {La vie d\'un bâtard n\'était pas facile : l\'homme était constamment traqué par des demi-frères jaloux. | Comme une sorte de lépreux royal, le bâtard était tenu à l\'écart des regards. | Heureusement, pendant la plus grande partie de sa vie, %name% ne savait pas qu\'il était un enfant bâtard. | Une controverse à la naissance, %name% n\'a été épargné de l\'abandon que par les présages d\'un oracle local. | Le fait d\'être un bâtard royal a permis à l\'homme de mener une belle vie, tant qu\'il gardait la tête basse, et son statut indésirable encore plus bas. | La haine des étrangers et de la famille a endurci le bâtard pour les difficultés éventuelles en dehors de son éducation royale.} {Fâché par son rôle dans la vie, %name% a tenté un coup d\'état pour prendre le trône. Il n\'est pas allé loin. Il est maintenant banni de toutes les cours du pays. | Quand un demi-frère l\'a bombardé de pierres, %name% n\'a eu aucun remords à le transpercer d\'une épée. Il a mis cela sur le dos d\'un serviteur, mais a rapidement quitté son logement royal par la suite. | Le père de %name% a essayé de le faire passer pour légitime, mais lorsqu\'un mariage royal a échoué, le scandale d\'inconvenance qui s\'en est suivi a été trop fort. Le bâtard erre désormais dans le pays, libéré des chaînes de la controverse. | Etre le fils aîné de la lignée faisait de %name% une cible pour ses jeunes frères légitimes. C\'était un choix facile de quitter cette vie de politique et de trahison. | Trouvé au lit avec une demi-sœur, les scandales dans la vie de %name% deviennent bien trop lourds pour rester dans les cours royales. | Fatigué des futilités des processions royales, %name% ne souhaite que rejoindre un groupe d\'hommes qui se moquent des lignées et de la légitimité. | Lorsqu\'un assassin empoisonna le vin de son père, %name% fut rapidement accusé du meurtre. Echapper à une foule en colère n\'était que le début d\'une nouvelle vie passionnante. | Bien qu\'il en vienne à l\'aimer tendrement, le père de %name% savait que la cour royale n\'était pas sûre. Il a envoyé l\'homme loin pour se forger une vie à sa façon.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				-5,
				-5
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				5,
				10
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				-5,
				5
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				0,
				0
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(0, 4) == 4)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.BastardTitles[this.Math.rand(0, this.Const.Strings.BastardTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/falchion"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/shortsword"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/hand_axe"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/shields/wooden_shield"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/padded_leather"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/basic_mail_shirt"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/nasal_helmet"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/padded_nasal_helmet"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
	}

});

