this.troublemakers_bully_peasants_event <- this.inherit("scripts/events/event", {
	m = {
		Troublemaker = null,
		Peacekeeper = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.troublemakers_bully_peasants";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%townImage%Entering %townname%, il ne faut pas longtemps pour que le %troublemaker% embête les habitants. Il leur arrache les seaux des mains et jette les femmes dans la boue à coups de pied. Quand un vieil homme lui fait face, le mercenaire sort son arme. Les autres paysans vous supplient de mettre fin à cette situation immédiatement.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je n\'ai pas le temps pour ça.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Tu dois arrêter ça, %troublemaker%. Ça donne une mauvaise image de la compagnie.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Remettez les paysans à leur place et fouillez leurs maisons pour trouver des objets de valeur !",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Peacekeeper != null)
				{
					this.Options.push({
						Text = "%peacekeeperfull%, voit si tu peux calmer %troublemaker% avec ta sagesse.",
						function getResult( _event )
						{
							return this.Math.rand(1, 100) <= 70 ? "E" : "F";
						}

					});
				}

				this.World.Assets.addMoralReputation(-1);
				local f = _event.m.Town.getFactionOfType(this.Const.FactionType.Settlement);
				f.addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Un de vos hommes a fait des ravages en ville.");
				this.Characters.push(_event.m.Troublemaker.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%townImage%Vous haussez les épaules.%troublemaker% ne transperce pas le vieil homme, mais il menace de le faire, en levant son arme bien haut. Lorsque le vieil homme se recroqueville, le mercenaire lui assène un coup de poing qui le met KO, ses dents se répandant dans la boue comme des gerbes de pluie blanche. Cela provoque quelques huées de la part des villageois, mais ils savent qu\'ils ne doivent plus contester votre présence.\n\n Quelques hommes traînent le vieillard tandis que les enfants huent et les femmes sifflent. Un enfant court même vers le mercenaire, le montrant du doigt en criant : \"C\'est un mauvais homme\". %troublemaker% hausse les épaules en rengainant son arme. %SPEECH_ON% Et pourtant, le mauvais homme est toujours là. Tu veux aussi goûter à la boue, mon petit ? %SPEECH_OFF%Le gamin s\'enfuit rapidement.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Maintenant, passons aux choses qui comptent vraiment...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Troublemaker.getImagePath());
				this.World.Assets.addMoralReputation(-3);
				local f = _event.m.Town.getFactionOfType(this.Const.FactionType.Settlement);
				f.addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Un de vos hommes a fait des ravages en ville");
				_event.m.Troublemaker.improveMood(1.0, "A intimidé les paysans");

				if (_event.m.Troublemaker.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Troublemaker.getMoodState()],
						text = _event.m.Troublemaker.getName() + this.Const.MoodStateEvent[_event.m.Troublemaker.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "%townImage%As %troublemaker% lève son arme en l\'air, vous l\'attrapez par l\'avant-bras et la ramenez vers le bas. Il se retourne et vous regarde d\'un air sévère. Le vieil homme recule et est bientôt récupéré par des soignants qui le ramènent à l\'intérieur avant qu\'il ne se blesse.\n\n- Quelques autres paysans s\'attardent, observant avec un vif intérêt. Vous dites au mercenaire de se retirer. Il est payé pour se battre contre qui vous jugez qu\'il doit se battre, pas contre une bande de paysans qui s\'occupent de leurs affaires. Alors que %troublemaker% jette un coup d\'oeil autour de lui, vous réalisez que vous ne lui avez laissé aucune \"sortie\" qui lui permettrait de sauver la face. Dans ses yeux, il y a un regard qui dit qu\'il est sur le point de vous tuer. Ce serait sa fin, mais il s\'en irait avec sa fierté suicidaire intacte. Mais le regard s\'estompe, et l\'embarras et l\'humiliation prennent sa place. Il rengaine son arme, crache, et remarque qu\'il ne faisait que s\'amuser.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Gardez ça pour quand on sera payés pour le faire.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Troublemaker.getImagePath());
				_event.m.Troublemaker.worsenMood(2.0, "A été humilié devant la compagnie.");

				if (_event.m.Troublemaker.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Troublemaker.getMoodState()],
						text = _event.m.Troublemaker.getName() + this.Const.MoodStateEvent[_event.m.Troublemaker.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_30.png[/img]Vous regardez le paysan qui vous a hélé.%SPEECH_ON%Qui es-tu, paysan, pour me dire à moi ou à mes hommes ce que je dois faire?%SPEECH_OFF%L\'homme recule d\'un pas, bredouillant quelque chose comme \"j\'essaie seulement d\'aider\". En riant, vous dites à vos hommes de prendre ce qu\'ils veulent. Si ce village n\'a aucun respect pour l\'autorité des hommes armés, alors vous allez devoir leur apprendre ce respect.\n\nLes femmes crient et emmènent leurs enfants lorsque l\'ordre sort de votre bouche. Elles s\'enfuient et quelques hommes les rejoignent. D\'autres hommes restent en arrière, protégeant leurs maisons, mais %companyname% se débarrasse rapidement de leurs modestes défenses. Vos mercenaires sont bientôt en train de piller chaque maison, prenant ce qu\'ils peuvent avec des rires rugissants. Aujourd\'hui est un bon jour.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ça leur apprendra.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Troublemaker.getImagePath());
				this.World.Assets.addMoralReputation(-5);
				local f = _event.m.Town.getFactionOfType(this.Const.FactionType.Settlement);
				f.addPlayerRelation(this.Const.World.Assets.RelationAttacked, "Vous avez pillé la ville");
				local money = this.Math.rand(100, 500);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getBackground().isCombatBackground())
					{
						bro.improveMood(1.0, "A apprécié les raids et les pillages");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getBackground().isOffendedByViolence() && this.Math.rand(1, 100) <= 75)
					{
						bro.worsenMood(1.0, "A été choqué par la conduite de la compagnie.");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "%townImage%%peacekeeperfull% se place entre %troublemaker% et le vieil homme. Il secoue la tête de façon très modeste, mais on ne peut s\'empêcher de remarquer que sa main armée est également posée sur le pommeau de son arme. Le mercenaire fauteur de troubles semble brièvement envisager d\'abattre l\'homme, mais un sourire se dessine sur son visage. Il rit en rengainant son arme.%SPEECH_ON%Je m\'amuse un peu, mon frère.%SPEECH_OFF%Les paysans reprennent lentement leurs activités, mais ils sont méfiants et regardent vos hommes avec des yeux de côté pour le reste de votre séjour dans %townname%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bien joué.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Troublemaker.getImagePath());
				this.Characters.push(_event.m.Peacekeeper.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "%townImage%%peacekeeperfull% s\'interpose entre le %troublemaker% et le vieil homme. Le mercenaire fauteur de troubles rit et rengaine son arme. Il se retourne vers le reste de la compagnie en souriant et en secouant la tête, mais vous remarquez que ce sourire s\'efface rapidement. Avant que vous ne puissiez dire quoi que ce soit, %troublemaker% brandit à nouveau son poing et assomme %peacekeeper%.\n\nHé bien, c\'est aussi une façon de calmer un mercenaire.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je devrais peut-être faire quelque chose pour la discipline dans cette compagnie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Troublemaker.getImagePath());
				this.Characters.push(_event.m.Peacekeeper.getImagePath());
				local injury = _event.m.Peacekeeper.addInjury(this.Const.Injury.Knockout);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Peacekeeper.getName() + " souffre de " + injury.getNameOnly()
				});
				_event.m.Peacekeeper.worsenMood(2.0, "A été humilié devant la compagnie.");

				if (_event.m.Peacekeeper.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Peacekeeper.getMoodState()],
						text = _event.m.Peacekeeper.getName() + this.Const.MoodStateEvent[_event.m.Peacekeeper.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_troublemaker = [];
		local candidates_peacekeeper = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getSkills().hasSkill("trait.brute") || bro.getBackground().getID() == "background.raider" || bro.getBackground().getID() == "background.sellsword" || bro.getBackground().getID() == "background.hedge_knight" || bro.getBackground().getID() == "background.brawler")
			{
				candidates_troublemaker.push(bro);
			}
			else if (bro.getBackground().getID() == "background.monk" || bro.getBackground().getID() == "background.monk_turned_flagellant")
			{
				candidates_peacekeeper.push(bro);
			}
		}

		if (candidates_troublemaker.len() == 0)
		{
			return;
		}

		this.m.Troublemaker = candidates_troublemaker[this.Math.rand(0, candidates_troublemaker.len() - 1)];

		if (candidates_peacekeeper.len() != 0)
		{
			this.m.Peacekeeper = candidates_peacekeeper[this.Math.rand(0, candidates_peacekeeper.len() - 1)];
		}

		this.m.Town = town;
		this.m.Score = candidates_troublemaker.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"troublemaker",
			this.m.Troublemaker.getName()
		]);
		_vars.push([
			"peacekeeper",
			this.m.Peacekeeper != null ? this.m.Peacekeeper.getNameOnly() : ""
		]);
		_vars.push([
			"peacekeeperfull",
			this.m.Peacekeeper != null ? this.m.Peacekeeper.getName() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Troublemaker = null;
		this.m.Peacekeeper = null;
		this.m.Town = null;
	}

});

