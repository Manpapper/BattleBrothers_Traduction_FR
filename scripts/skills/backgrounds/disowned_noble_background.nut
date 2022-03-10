this.disowned_noble_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.disowned_noble";
		this.m.Name = "Disowned Noble";
		this.m.Icon = "ui/backgrounds/background_08.png";
		this.m.BackgroundDescription = "Disowned nobles often have profited from some training in melee fighting at court.";
		this.m.GoodEnding = "A noble at heart, the disowned nobleman %name% returned to his family. Word has it he kicked in the doors and demanded a royal seat. An usurper challenged him in combat and, well, %name% learned a lot in his days with the %companyname% and he now sits on a very, very comfortable throne.";
		this.m.BadEnding = "A man of nobility at heart, %name% the disowned noble returned to his family home. Word has it an usurper arrested him at the gates. His head currently rests on a pike with crows for a crown.";
		this.m.HiringCost = 135;
		this.m.DailyCost = 17;
		this.m.Excluded = [
			"trait.teamplayer",
			"trait.clumsy",
			"trait.fragile",
			"trait.spartan",
			"trait.clubfooted"
		];
		this.m.Titles = [
			"the Disowned",
			"the Exiled",
			"the Disgraced"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Thick;
		this.m.Level = this.Math.rand(1, 3);
		this.m.IsCombatBackground = true;
		this.m.IsNoble = true;
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
		return "{A constant disappointment to a delusional father | A victim of court intrigue involving poison and cake | After openly denouncing his own heritage | After an incestous relationship with his sister came to light | After a coup to dispose his older brother failed | After pride and hubris had him leading his father\'s army to total defeat | For accidentally killing his oldest brother and heir to the throne on a hunt | As a price to be paid for choosing his allies poorly in a war of succession | For attempting to sell captured poachers as slaves | Caught bedding a fellow nobleman | Discovered to be the head of a child stealing plot that shocked the peasantry | For turning his back on the gods and causing a riot amongst the laymen | Seen with the cultists\' book of Davkul tucked under an arm}, %name% {was disowned and cast away from his family\'s estate, never to return. | was stripped of his titles and exiled from the land. | was forcibly removed from his land and told never to return. | came to see, by the threat of an executioner\'s axe, that he no longer belonged in the court. | saw the hangman\'s noose, and only by a clever ploy did he slip it. | was branded with the symbol of shame and cast out from his lands. | was believed to have been involved in one too many conspiracies and was removed from the lands. | was seen as being too ambitious, a dangerous trait amongst the nobility.} {%name% now seeks to redeem himself and live up to the family name. A bit selfish for a mercenary outfit, noble nonetheless. | His posture slumped by scandal, %name%\'s resistance to difficulties has diminished. | A skilled fighter he may be, but %name% rarely talks about anyone but himself. | Though quick with a sword, you get the feeling someone like %name% was disowned for a reason. | Down on his luck and essentially broke, %name% ventures in the field of sellswords. | Without title or land, %name% seeks to join the sort of men he used to lord over. | Well-geared this former noble may be, you do notice that the most used piece of equipment %name% has are his boots.}";
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
				-2
			],
			Stamina = [
				-10,
				-5
			],
			MeleeSkill = [
				8,
				10
			],
			RangedSkill = [
				3,
				6
			],
			MeleeDefense = [
				0,
				3
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

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/shortsword"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/hatchet"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/militia_spear"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/shields/wooden_shield"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/shields/buckler_shield"));
		}

		r = this.Math.rand(0, 5);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/padded_leather"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/gambeson"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/basic_mail_shirt"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/mail_shirt"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/armor/mail_hauberk"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}

		r = this.Math.rand(0, 8);

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
			items.equip(this.new("scripts/items/helmets/aketon_cap"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/full_aketon_cap"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/helmets/mail_coif"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/helmets/feathered_hat"));
		}
	}

});

