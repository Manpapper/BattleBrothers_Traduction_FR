this.the_horseman_event <- this.inherit("scripts/events/event", {
	m = {
		Flagellant = null,
		Butcher = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.the_horseman";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%Sur le chemin, vous apercevez un homme suspendu à une branche d\'arbre, la tête en bas. Un groupe d\'hommes est assis autour de lui et partage une gourde en peau de chèvre, comme s\'ils étaient à la fin d\'une journée de dur labeur. Quand vous demandez ce qui se passe, l\'un d\'entre eux lève les yeux et sourit.%SPEECH_ON%On fouette ce gars jusqu\'à ce qu\'il soit à vif.%SPEECH_OFF%Vous demandez pourquoi. Un autre homme répond.%SPEECH_ON%Il baisait la femme de ce type.%SPEECH_OFF%Un homme qui boit gicle et s\'étouffe avec son verre. Il s\'essuie la bouche.%SPEECH_ON%Pas vraiment baiser ma femme. Non, cette ordure s\'est fait prendre en train de niquer dans mon cheval mort.%SPEECH_OFF%.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Allons parler à l\'homme qui se balance.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Continuons.",
					function getResult( _event )
					{
						if (_event.m.Butcher != null)
						{
							return "Butcher";
						}
						else
						{
							return 0;
						}
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%terrainImage%Vous vous dirigez vers l\'homme suspendu. Il y a du sang qui coule dans son dos, provenant d\'une douzaine d\'entailles. Il a un tissu qui lui couvre les yeux et vous le retirez. Clignant des yeux, il demande ce que vous voulez, comme si vous interrompiez sa propre cachette. Vous lui demandez si ce qu\'ils disent est vrai. Il crache et se racle la gorge.%SPEECH_ON% Je veux dire, oui, mais le cheval était mort, alors quelle importance cela avait-il ? Le propriétaire du cheval se lève, brandissant un fouet dégoulinant. %SPEECH_ON%Oy, vous voulez qu\'on continue ? On a toute la journée!%SPEECH_OFF%Soupirant, l\'homme suspendu te pose alors une question Pourquoi je ne viens pas me battre pour toi ? Je suis un homme fort et valide, un peu de cheval, je veux dire à cheval, mais ça mis à part, et le, euh, truc de l\'animal mort, je suis un homme sensible.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous alloins te tuer",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 75)
						{
							return "C";
						}
						else
						{
							return "D";
						}
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Flagellant != null)
				{
					this.Options.push({
						Text = "%flagellantfull%, on dirait que tu as quelque chose en tête.",
						function getResult( _event )
						{
							return "Flagellant";
						}

					});
				}

				this.Options.push({
					Text = "Il est temps de partir.",
					function getResult( _event )
					{
						if (_event.m.Butcher != null)
						{
							return "Butcher";
						}
						else
						{
							return 0;
						}
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "%terrainImage%Vous sortez votre lame et détachez l\'homme. Il s\'effondre sur ses épaules et s\'étale, son dos fouetté dans la terre. La terre pourrait aussi bien être du sel à en juger par ses gémissements. L\'un des fouetteurs se lève.%SPEECH_ON%Hey, qu\'est-ce que vous pensez être en train de faire ? On n\'a pas fini ici!%SPEECH_OFF%%randombrother% sort son arme et l\'homme recule. Le propriétaire du cheval crache et secoue la tête.%SPEECH_ON%Vous allez vraiment défendre cet animal ? N\'est-ce pas une putain de connerie ? Je suppose que maintenant je peux dire que j\'ai tout vu et c\'est exactement ce que j\'ai dit quand j\'ai attrapé ce bâtard en train de tripoter mon cheval mort!%SPEECH_OFF%L\'homme reprend son souffle puis pointe l\'homme récemment sauvé.%SPEECH_ON%J\'espère que tu mourras dès ton premier jour de sortie, espèce de bâtard tripoteur de pouliche.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bienvenue à bord, espèce de pute de cheval.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				},
				{
					Text = "Va-t\'en.  Nous n\'avons pas de place pour toi.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"vagabond_background"
				]);
				_event.m.Dude.setTitle("the Filly Fiddler");
				_event.m.Dude.getBackground().m.RawDescription = "Vous avez trouvé %name% se faisant fouetter pour s\'être impliqué avec un cheval mort. Espérons que ce passé est, euh, derrière lui maintenant.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.setHitpoints(30);
				_event.m.Dude.improveMood(1.0, "A satisfait ses besoins avec un cheval mort");
				_event.m.Dude.worsenMood(1.0, "A été fouetté");

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "%terrainImage%Vous sortez votre lame et coudétachez l\'homme. Il tombe directement sur la tête et son cou se brise avec un craquement dégoûtant. Le reste de son corps s\'effondre avec ses jambes maladroitement repliées sur sa propre poitrine, une position sans doute étrange pour ce déviant sexuel. Le propriétaire du cheval se lève d\'un bond.%SPEECH_ON%Bon sang, monsieur, nous allions juste le fouetter. Pourquoi vous l\'avez tué ?%SPEECH_OFF%Il fait une pause puis agite une main dédaigneuse.%SPEECH_ON%Merde, mec. Bon, d\'accord. Nous allons tous partir à notre manière et ne rien dire de ce qui s\'est passé ici. C\'est pas vrai les gars ?%SPEECH_OFF% Les autres hommes hochent la tête.%SPEECH_ON%Bien sûr. Je ne vais pas gâcher ma vie pour un violeur. Bien joué, mercenaire, stupide balançoire à épée.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Whoops.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Flagellant",
			Text = "%terrainImage%%flagellant% s\'avance et prend le fouet du propriétaire du cheval. Il le plie et passe le cuir entre ses mains. En hochant la tête, il dit que c\'est un \"bel outil\" pour un bon fouettement, mais que les hommes s\'y prenaient \"de la mauvaise manière\". Il montre les blessures sur le dos de l\'homme. Vous voyez ces stries ? Elles sont fines et à peine ouvertes. Ne te laisse pas tromper par la quantité de sang, elles sont superficielles. Tiens, laisse-moi te montrer une bonne méthode.%SPEECH_OFF%Le flagellant fait tomber les cordes du fouet, les fait tourner pendant un moment, puis frappe. Le pendu crie. Une plaie s\'ouvre et s\'élargit de la pointe d\'une côte à la pointe d\'une autre, en passant par son dos. On peut voir les muscles et la graisse qui bouillonnent en dessous. Le %flagellant% frappe encore, et encore, et encore. Le sang éclabousse le flagellant pendant qu\'il travaille et le cavalier s\'est depuis longtemps évanoui. Finalement, l\'un des hommes se lève et reprend le fouet.%SPEECH_ON%C\'est assez. Vous, les gars, montez et partez, d\'accord ? Putain quel enfer...%SPEECH_OFF%Un autre homme descend le violeur et soigne ses nouvelles blessures, assez graves. %flagellant% s\'essuie le front et admire son travail.%SPEECH_ON%Mmhmm, c\'est comme ça qu\'on fait.%SPEECH_OFF%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Oui, c\'est vrai.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Flagellant.getImagePath());
				local meleeSkill = 1;
				local fatigue = 1;
				_event.m.Flagellant.getBaseProperties().MeleeSkill += meleeSkill;
				_event.m.Flagellant.getBaseProperties().Stamina += fatigue;
				_event.m.Flagellant.getSkills().update();
				_event.m.Flagellant.improveMood(1.0, "A mis à profit ses compétences uniques");

				if (_event.m.Flagellant.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Flagellant.getMoodState()],
						text = _event.m.Flagellant.getName() + this.Const.MoodStateEvent[_event.m.Flagellant.getMoodState()]
					});
				}

				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Flagellant.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeSkill + "[/color] de Maîtrise de Mêlée"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Flagellant.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + fatigue + "[/color] de Fatigue Maximum "
				});
			}

		});
		this.m.Screens.push({
			ID = "Butcher",
			Text = "%terrainImage%%butcher% demande si le cheval est toujours là. Son propriétaire hoche la tête.%SPEECH_ON%Oui, fraîchement mort, fraîchement souillé par cet endouille. Pourquoi ? %SPEECH_OFF%Le boucher demande s\'il peut le récuperer. Le propriétaire hausse les épaules. %SPEECH_ON%C\'est à toi si tu le veux. Mais tu ferais mieux de faire attention en coupant autour des morceaux qu\'il a touché avec ses propres morceaux.%SPEECH_OFF%Avant que l\'on puisse en dire plus, %butcher% demande à l\'homme de l\'emmener au cadavre du cheval pour, eh bien, le découper. La compagnie a de la viande douteuse à manger.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je ne suis pas sûr de vouloir ça dans nos stocks.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Butcher.getImagePath());
				local item = this.new("scripts/items/supplies/strange_meat_item");
				this.World.Assets.getStash().add(item);
				item = this.new("scripts/items/supplies/strange_meat_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y < this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidate_flagellant = [];
		local candidate_butcher = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.flagellant")
			{
				candidate_flagellant.push(bro);
			}
			else if (bro.getBackground().getID() == "background.butcher")
			{
				candidate_butcher.push(bro);
			}
		}

		if (candidate_flagellant.len() != 0)
		{
			this.m.Flagellant = candidate_flagellant[this.Math.rand(0, candidate_flagellant.len() - 1)];
		}

		if (candidate_butcher.len() != 0)
		{
			this.m.Butcher = candidate_butcher[this.Math.rand(0, candidate_butcher.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"flagellant",
			this.m.Flagellant != null ? this.m.Flagellant.getNameOnly() : ""
		]);
		_vars.push([
			"flagellantfull",
			this.m.Flagellant != null ? this.m.Flagellant.getName() : ""
		]);
		_vars.push([
			"butcher",
			this.m.Butcher != null ? this.m.Butcher.getNameOnly() : ""
		]);
		_vars.push([
			"butcherfull",
			this.m.Butcher != null ? this.m.Butcher.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Flagellant = null;
		this.m.Butcher = null;
		this.m.Dude = null;
	}

});

