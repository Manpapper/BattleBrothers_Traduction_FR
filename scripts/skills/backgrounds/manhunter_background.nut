this.manhunter_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.manhunter";
		this.m.Name = "Chasseur d\'hommes";
		this.m.Icon = "ui/backgrounds/background_62.png";
		this.m.BackgroundDescription = "Les chasseurs d\'hommes sont habitués à traquer les gens dans la rude région du sud.";
		this.m.GoodEnding = "%name% le chasseur d\'hommes est resté avec la compagnie %companyname% pendant un long moment après que vous l\'ayez quittée. Vous n\'avez pas eu beaucoup de nouvelles de cet homme, à part que ces revenus sont bien supérieurs dans le monde des mercenaires que dans celui de la chasse aux endettés.";
		this.m.BadEnding = "Mécontent de la façon dont s\'est déroulé son séjour dans la compagnie %companyname%, %name% le chasseur d\'hommes a déserté et est retourné dans le sud. Il est difficile de dire ce qu\'il est devenu, mais le métier de traqueur et de chasseur de proies humaines comporte des dangers infinis. Les seules nouvelles que vous avez de lui sont secondaires à sa profession: celle de nombreux soulèvements endettés, avec de nombreux chasseurs d\'hommes enterrés vivants ou donnés en pâture à diverses créatures du désert.";
		this.m.HiringCost = 120;
		this.m.DailyCost = 10;
		this.m.Excluded = [
			"trait.bleeder",
			"trait.bright",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.iron_lungs",
			"trait.tiny",
			"trait.optimist",
			"trait.dastard",
			"trait.asthmatic",
			"trait.craven",
			"trait.insecure",
			"trait.short_sighted"
		];
		this.m.Titles = [
			"the Manhunter",
			"the Mancatcher",
			"the Hunter",
			"the Ruthless",
			"the Bounty Hunter",
			"the Brutal",
			"the Cruel",
			"the Unforgiving",
			"the Merciless",
			"the Tracker",
			"the Catcher",
			"the Heartless",
			"the Swine",
			"the Slaver"
		];
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.BeardChance = 90;
		this.m.Bodies = this.Const.Bodies.SouthernThick;
		this.m.Ethnicity = 1;
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
		this.m.IsLowborn = true;
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
		return "{L\'importante population d\'esclaves, de prisonniers, de criminels et de serviteurs endettés du Sud a engendré une économie de vendeurs, d\'acheteurs et, étant donné la nature volage du produit, de chasseurs. | Les villes-états du sud doivent disposer d\'énormes réserves de main-d\'œuvre pour alimenter leur économie dans le désert. Si beaucoup sont nés pour travailler sans relâche pour les Vizirs, certains doivent être contraints à une vie de servitude. | Les déserts sont si pauvres en ressources naturelles que ce sont souvent les criminels capturés et les âmes endettées qui renforcent l\'économie du sud. Et la chasse à ces éventuels serviteurs est un commerce prospère. | Les vizirs du Sud craignent tellement les révoltes qu\'un marché entier de chasseurs d\'hommes a vu le jour pour étouffer les rébellions dans l\'œuf.} {%name% est entré dans la chasse à l\'homme avec une intention de vengeance : toute sa famille a été massacrée lors d\'une révolte d\'esclaves. | %name% était autrefois un simple garde de caravane, mais il s\'est tourné vers les nomades chasseurs d\'hommes qui tentaient sans cesse de tendre des embuscades à ses convois. Trouvant plus de profit dans le commerce humain, il s\'y est consacré. | %name% est un chasseur d\'hommes qui a le nez pour traquer les criminels, les déserteurs, les prisonniers de guerre, etc. On se demande parfois s\'il n\'a pas un sens aigu de l\'odorat pour sentir la peur. | Autrefois chasseur de gros gibier, %name% a pris goût à chasser le plus grand gibier de tous les temps: l\'Homme . C\'est un traqueur expert qui a le nez pour flairer le désespoir.} {Pour %name%, l\'opportunité de travailler pour une bande de mercenaires apporte simplement un travail plus régulier que de devoir attendre qu\'un criminel s\'évade. | %name% est un individu louche et robuste et il est fort possible qu\'il soit aussi instable que les hommes qu\'il a cherché à traquer. | Les chasseurs comme %name% possèdent des traits de caractère et des compétences qui seraient utiles dans un groupe de mercenaires, mais pour certains, leur passé peut être un handicap permanent. Les chasseurs d\'hommes ne sont pas toujours bien vus. | Capturer des humains dans le but de les faire travailler est mal perçu par beaucoup et capturer ceux qui recherchent leur liberté l\'est tout autant. Les chasseurs d\'hommes comme %name% ont certainement des compétences utiles, mais ils peuvent en irriter certains. | Sans surprise, beaucoup voient les hommes comme %name% comme des limaces opportunistes. S\'il peut s\'imposer dans la compagnie, il faudra peut-être du temps à certains pour changer d\'avis sur son passé.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				2,
				3
			],
			Bravery = [
				7,
				5
			],
			Stamina = [
				3,
				5
			],
			MeleeSkill = [
				5,
				5
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				2,
				2
			],
			RangedDefense = [
				-1,
				-1
			],
			Initiative = [
				3,
				5
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/battle_whip"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/bludgeon"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/oriental/saif"));
		}

		items.equip(this.new("scripts/items/tools/throwing_net"));
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/oriental/nomad_robe"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/oriental/thick_nomad_robe"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/oriental/southern_head_wrap"));
		}
	}

});

