this.anatomist_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.anatomist";
		this.m.Name = "Anatomiste";
		this.m.Icon = "ui/backgrounds/background_70.png";
		this.m.BackgroundDescription = "En partie scientifiques et en partie chirurgiens, les anatomistes ne sont pas spécialement taillés pour le combat mais on peut toujours compter sur leurs mains expertes.";
		this.m.GoodEnding = "Parmi tous les hommes que vous avez appris à connaître dans la compagnie %companyname%, c\'est %name% l\'anatomiste qui est peut-être le plus difficile à oublier. Un flot ininterrompu de lettres ne fait qu\'assurer que vous ne le ferez jamais. Vous parcourez sa dernière correspondance: \"Capitaine! J\'ai réussi à ...\" passe certains paragraphes, \"...la plus grande invention! La plus...\" passe certains paragraphes. \"Je vais devenir célèbre! Mon cerveau sera sûrement étudié pour son poids...\" Rien de nouveau, semble-t-il, bien que vous soyez heureux qu\'il soit toujours en bonne santé, bien que peut-être plus dans son corps que dans son esprit...";
		this.m.BadEnding = "Ayant fui la compagnie %companyname%, %name% l\'anatomiste a poursuivi ses études ailleurs. Il a été réprimandé par ses pairs pour s\'être aventuré de manière aussi grossière et s\'est retrouvé à souffrir de sa médiocrité intellectuelle. Quelques années plus tard, il a apporté une petite contribution à l\'étude des coléoptères, après quoi il s\'est rapidement jeté d\'une falaise en bord de mer, en faisant don de son cerveau aux rochers et de son corps à l\'océan.";
		this.m.HiringCost = 130;
		this.m.DailyCost = 8;
		this.m.Excluded = [
			"trait.ailing",
			"trait.asthmatic",
			"trait.bleeder",
			"trait.huge",
			"trait.determined",
			"trait.fear_beasts",
			"trait.hate_beasts",
			"trait.fear_greenskins",
			"trait.hate_greenskins",
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.teamplayer",
			"trait.impatient",
			"trait.clumsy",
			"trait.iron_jaw",
			"trait.dumb",
			"trait.athletic",
			"trait.brute",
			"trait.fragile",
			"trait.fainthearted",
			"trait.iron_lungs",
			"trait.irrational",
			"trait.cocky",
			"trait.strong",
			"trait.tough",
			"trait.superstitious"
		];
		this.m.Titles = [
			"the Vulture",
			"the Crow",
			"the Magistrate",
			"the Mortician",
			"the Undertaker",
			"the Grim",
			"the Anatomist",
			"the Curious",
			"the Tainted"
		];
		this.m.Faces = this.Const.Faces.SmartMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
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
		return "{%name% était un homme vif au teint ravagé par les virulentes expériences qu\'il mena maintes années durant. Le scrutant, vous espérez que ses méthodologies s\'appliqueront mieux à vos ennemis qu\'à lui-même... | Des rumeurs couraient sur %name% ... On raconte qu\'autrefois, il multiplia les tentatives afin de percer le secret pour s\'envoler vers les cieux. Non pas avec une machine, mais plutôt en essayant de se faire pousser des ailes. Personne ne vit jamais le fruit de ses recherches, ni ce qu\'il advint de ses expérimentations ... Mais, à présent, il est bien là, les deux pieds sur le plancher des vaches ! | Comme de nombreux anatomistes, %name% s\'était aventuré seul dans le monde. Bien sûr, comme beaucoup, il fût rapidement dévoré par la convoitise de ceux pour qui la science ne signifiait rien. À présent, il se battra aux côtés de mercenaires, ne serait-ce que pour gagner du temps et se consacrer à ses études. | %name% faisait preuve de beaucoup de cynisme. En effet, contrarié par le fait que certains de ses pairs pouvaient s\'adonner à leurs études sans soucis, pendant lui devait gagner de l\'argent juste pour financer les siennes. Bien. Espérons que sa colère ruminante se manifeste sur le champ de bataille. | On s\'attendrait à ce qu\'un homme comme %name% apparaisse après une bataille, et non qu\'il y participe. Le fait qu\'un personnage aussi intelligent, bien qu\'étrange, ait encore besoin de l\'argent d\'un maître d\'hôtel vous amène à vous demander si vos propres chances d\'arriver à quelque chose dans ce monde ne sont pas pires que vous ne le pensiez. | On ne peut pas surestimer l\'intelligence de %name%. C\'est un homme méchamment intelligent, du genre à vous faire vous demander pourquoi les dieux ont pris la peine de vous donner un esprit propre s\'il doit être à ce point éclipsé. Mais, en matière d\'épée, il serait juste un autre combattant. Espérons que ses compétences martiales soient aussi aiguisées que son esprit. | On ne peut jamais savoir avec certitude si ce sont des temps difficiles qui ont poussé %name% à se lancer dans la vente d\'armes, ou s\'il ne fait que poursuivre des recherches scientifiques par un autre chemin, bien plus cruel. Le fait qu\'il passe ses soirées à disséquer des chiens écrasés par un wagon et des papillons sans ailes vous fait réfléchir à beaucoup de choses sur ce curieux personnage. | C\'est la curiosité, et non l\'argent, qui amena %name% à la vente de mots. En effent, Il avait un vif intérêt pour la découverte des créatures peuplant le monde, et de ce à quoi elles ressemblaient à l\'intérieur. Eh bien ... Tant qu\'il rendra ces entrailles visibles, vous ne vous soucierez pas de ce qu\'il en fera}.";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-4,
				-4
			],
			Bravery = [
				10,
				10
			],
			Stamina = [
				0,
				-5
			],
			MeleeSkill = [
				7,
				7
			],
			RangedSkill = [
				9,
				9
			],
			MeleeDefense = [
				1,
				0
			],
			RangedDefense = [
				1,
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
		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r <= 2)
		{
			items.equip(this.new("scripts/items/weapons/dagger"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/butchers_cleaver"));
		}

		r = this.Math.rand(0, 5);

		if (r < 3)
		{
			items.equip(this.new("scripts/items/armor/undertaker_apron"));
		}
		else if (r < 5)
		{
			items.equip(this.new("scripts/items/armor/wanderers_coat"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/armor/reinforced_leather_tunic"));
		}

		r = this.Math.rand(0, 5);

		if (r < 3)
		{
			items.equip(this.new("scripts/items/helmets/undertaker_hat"));
		}
		else if (r < 5)
		{
			items.equip(this.new("scripts/items/helmets/physician_mask"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/helmets/masked_kettle_helmet"));
		}
	}

});

