this.something_in_barn_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		BeastSlayer = null,
		Farmer = null
	},
	function create()
	{
		this.m.ID = "event.something_in_barn";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Un homme vient à l\'encontre de la compagnie en disant qu\'il y a un méléfique chiot loup-garou piégé dans sa grange. %anatomist% l\'anatomiste entend cela et se rapproche. Il demande s\'il est certain que le chiot est maléfique. L\'étranger acquiesce.%SPEECH_ON%A moitié loup-garou, j\'imagine que son pedigree est imprégné du mal. Cette foutue chose est enfermée dans la grange et il n\'y a qu\'une seule entrée, c\'est un peu risqué.%SPEECH_OFF%Il vous demande d\'aller tuer le petit avant qu\'il ne s\'échappe. %anatomiste% est assez curieux car on sait très peu de choses sur les loups-garous lorsqu\'ils sont jeunes. Il se porte volontaire pour vous accompagner et s\'occuper de cette créature infantile}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Allons voir ça.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 55 ? "B" : "C";
					}

				},
				{
					Text = "C\'est pas notre problème.",
					function getResult( _event )
					{
						return "F";
					}

				}
			],
			function start( _event )
			{
				if (this.Const.DLC.Unhold && _event.m.BeastSlayer != null)
				{
					this.Options.push({
						Text = "%beastslayer% le tueur de bêtes devrait s\'en occuper.",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.Farmer != null)
				{
					this.Options.push({
						Text = "Notre fermier %farmer% semble avoir une idée.",
						function getResult( _event )
						{
							return "E";
						}

					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_27.png[/img]{Vous acceptez la demande de l\'étranger et vous vous rendez à la grange. Elle est assez quelconque, il vous explique encore une fois qu\'il n\'y a qu\'une seule entrée. Il s\'appuie contre la porte et écoute, puis fait un signe de tête.%SPEECH_ON%Ah oui, il est toujours là, c\'est sûr.%SPEECH_OFF%La porte s\'ouvre et vous vous engrouffrez avec %anatomist% à l\'intérieur. Ce que vous voyez ressemble à des tas de merde, des cages avec des animaux effrayés, entassés et dressant la tête sur votre passage. Vous voyez au bout de la grange une créature mal fagotée qui fouille dans un tas de foin. Paniqué, %anatomist% attrape une fourche et part à l\'assaut. Vous le stoppez net en attrapant la fourche et en la faisant voler dans les airs. Vous lui criez dessus et pointez le doigt vers la créature. La bête n\'est pas du tout un loup-garou, mais juste un chien ordinaire, un bâtard aux yeux larmoyants. L\'homme se tient derrière vous et se frotte la nuque.%SPEECH_ON%Euh, ah, ouais, c\'est ma faute. J\'étais sûr que c\'était un loup-garou.%SPEECH_OFF%Avec un peu de nourriture et d\'entraînement, il y a peu de doutes que ce cabot pourrait être transformé en quelque chose d\'utile pour la compagnie %companyname%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tenez-le éloigné de %anatomist%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/accessory/wardog_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_06.png[/img]{Vous vous aventurez vers une grange quelconque dont la porte est couverte de chaînes. L\'homme s\'appuie sur le cadre pendant un moment, écoutant à travers, puis hoche la tête et enlève les chaînes. Alors qu\'il ouvre la porte, il se cache derrière vous et vous regarde.%SPEECH_ON%C\'est là, dans le foin.%SPEECH_OFF%Vous apercevez la forme de la bête. En dégainant votre épée, vous avancez en rampant. %anatomist%, lui, sursaute à sa vue, perdant tout sang-froid dans un glapissement sans grâce et un cri de femme. Il saisit une fourche et la plante dans le foin. La bête hurle lorsque l\'anatomiste enfonce les dents à plusieurs reprises, encore et encore, jusqu\'à ce que la créature soit tuée. Vous vous accroupissez et ramassez la paille pleine de sang. Ce n\'est pas du tout un loup-garou, pas même un soupçon d\'un petit chiot. En fait, c\'est juste un chien ordinaire. Au même moment, vous entendez une voix derrière vous. Ce n\'est pas du tout l\'homme qui est venu vous chercher, mais quelqu\'un d\'autre. Il crie que vous avez tué son chien. %anatomist% jette la fourche par terre. Il explique que c\'était une erreur. Comme l\'anatomiste a choisi d\'arbitrer lui-même la situation, vous vous empressez de fuir, n\'entendant que les faibles cris du propriétaire du chien et de l\'%anatomiste% qui tentent de faire valoir qu\'il s\'agissait d\'un accident. Vous avez essayé de trouver le salaud qui vous a piégé mais sans succès. Tout ce que vous pouvez faire, c\'est compter le stock tout en ignorant les gémissements du propriétaire du chien mort et les lamentations de %anatomist%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ouch.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(0.75, "Accidentally killed someone\'s dog");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_131.png[/img]{Si c\'est bien une bête, il vaut mieux que ce soit %beastslayer% qui vienne. Vous allez tous les trois dans la grange. Après être restés un moment sans bouger, vous comptez jusqu\'à trois et vous et le tueur de bêtes ouvrez les portes de la grange d\'un coup de pied. L\'anatomiste qui se trouve juste derrière n\'a pas compris quel était le plan. Il donne le dernier coup de pied, bien trop tard, sa botte brasse du vent et frappe violemment le sol. Il tente de retrouver sa dignité et de se relever, mais il semble s\'être froissé un muscle à l\'aine. Vous et %beastslayer% éclatez de rire. Alors que vous aidez l\'anatomiste à se relever, tout se passe très vite, un bruit sourd se produit contre l\'une des stalles de la grange. Vous regardez pour voir le tueur de bêtes embrocher une créature pâle et macabre, son arme lui transperçant le crâne tandis que son bras la tient par le cou.%SPEECH_ON%C\'est un chiot, d\'accord, mais ce n\'est certainement pas un loup-garou.%SPEECH_OFF%Dit-il. Il laisse tomber le petit nachzehrer sur le sol. Il regarde par-dessus.%SPEECH_ON%Il ressemble un peu à l\'anatomiste.%SPEECH_OFF%%anatomiste% prend la chose à bras le corps, se lève maladroitement et avance d\'un pas traînant. Il remarque que la bête peut encore être utile à la science. Bien qu\'il ne soit pas aussi brut de décoffrage que certains autres hommes, vous ne pouvez vous empêcher de respecter son professionnalisme.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Beau travail.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/misc/ghoul_teeth_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				_event.m.BeastSlayer.improveMood(1.0, "Put his monster slaying skills to use");

				if (_event.m.BeastSlayer.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.BeastSlayer.getMoodState()],
						text = _event.m.BeastSlayer.getName() + this.Const.MoodStateEvent[_event.m.BeastSlayer.getMoodState()]
					});
				}

				_event.m.Anatomist.worsenMood(0.5, "Embarrassed himself trying to slay a monster");
				_event.m.Anatomist.addXP(200, false);
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Anatomist.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] Experience"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.BeastSlayer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_131.png[/img]{%farmer% le fermier arrive. Il dit à l\'homme.%SPEECH_ON%Ce n\'était pas votre grange à l\'origine, n\'est-ce pas?%SPEECH_OFF%L\'homme secoue la tête. %farmer% acquiesce.%SPEECH_ON%Je m\'en doutais, parce que les granges comme celle-ci n\'ont pas qu\'une seule entrée. Il y a une sortie en terre intégrée, il suffit de savoir où regarder. Donnez-moi une seconde et je vais faire du bruit derrière en espérant qu\'elle sorte par la porte principale.%SPEECH_OFF%Comme prévu, vous attendez tous devant l\'entrée. Il ne faut pas longtemps avant d\'entendre le glapissement d\'une bête à l\'intérieur qui se rapproche de vous. A la seconde où elle fait un pas dehors, vous lui plantez une épée dans le crâne. Alors qu\'elle tombe au sol, vous réalisez que c\'est un petit nachzehrer. %anatomiste% frappe dans ses mains car il a quelque chose qui pourrait mériter d\'être examiné. %farmer% revient en tenant une longue arme à deux mains.%SPEECH_ON%On dirait que quelqu\'un à oublié ça derrière la grange. On va la prendre, ce sera notre façon de se faire payer n\'est ce pas?%SPEECH_OFF%Vous acquiescez, l\'homme qui a demandé votre aide ne proteste pas.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Beau travail.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local twoHanders = [
					"weapons/woodcutters_axe",
					"weapons/hooked_blade",
					"weapons/warbrand"
				];

				if (this.Const.DLC.Unhold)
				{
					twoHanders.extend([
						"weapons/two_handed_wooden_hammer",
						"weapons/two_handed_wooden_flail",
						"weapons/spetum",
						"weapons/goedendag"
					]);
				}

				local item = this.new("scripts/items/" + twoHanders[this.Math.rand(0, twoHanders.len() - 1)]);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				_event.m.Anatomist.improveMood(1.0, "Got to study an interesting specimen");
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Farmer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Malgré les souhaits de l\'%anatomiste, vous dites au paysan que s\'il y a bien un loup-garou dans la grange, il doit s\'en occuper lui-même. Ce genre de problème ne vous concerne pas. Dans le contraire, vous devez vous faire payer. Bon sang, peut-être que le chiot loup-garou sera d\'une aide précieuse pour la compagnie %companyname% une fois qu\'il sera grand et fort.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous gérons une entreprise ici.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(1.0, "Was denied a research opportunity");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary() || t.getSize() >= 2)
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomistCandidates = [];
		local beastSlayerCandidates = [];
		local farmerCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomistCandidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.beast_slayer")
			{
				beastSlayerCandidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.farmhand")
			{
				farmerCandidates.push(bro);
			}
		}

		if (beastSlayerCandidates.len() > 0)
		{
			this.m.BeastSlayer = beastSlayerCandidates[this.Math.rand(0, beastSlayerCandidates.len() - 1)];
		}

		if (farmerCandidates.len() > 0)
		{
			this.m.Farmer = farmerCandidates[this.Math.rand(0, farmerCandidates.len() - 1)];
		}

		if (anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getNameOnly()
		]);
		_vars.push([
			"beastslayer",
			this.m.BeastSlayer != null ? this.m.BeastSlayer.getNameOnly() : ""
		]);
		_vars.push([
			"farmer",
			this.m.Farmer != null ? this.m.Farmer.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.BeastSlayer = null;
		this.m.Farmer = null;
	}

});

