this.creepy_guy_event <- this.inherit("scripts/events/event", {
	m = {
		Thief = null,
		Minstrel = null,
		Butcher = null,
		Killer = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.creepy_guy";
		this.m.Title = "A %townname%";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_43.png[/img]En vous promenant dans les rues de %townname%, vous tombez sur une foule qui se tient autour d\'un pendu. Il devait avoir une certaine notoriété : les gens se bousculent pour essayer d\'obtenir un tour pour couper un orteil ou un doigt en guise de souvenir de pendaison. Un vieil homme est rapidement mis à l\'écart de la foule. Il se tourne vers vous, la voix rauque, ses doigts osseux tendus.%SPEECH_ON%Ahh, vous êtes un mercenaire ? Bien sûr, je peux sentir votre commerce, les achats que vous avez faits. Dites, vous pourriez faire un petit de travail pour moi ? J\'ai besoin d\'un certain nombre de doigts et d\'orteils de cet homme mort. C\'est pour mon travail, vous verrez. Je vous donnerai cinq cents couronnes en échange.%SPEECH_OFF%Vous demandez pourquoi il a besoin des appendices de cet homme en particulier. L\'homme rit.%SPEECH_ON%Oui, bonne question. L\'homme a rejoint le noeud du bourreau avec un penchant pour la violence et une force inébranlable pour aller au bout de ses désins. Les orteils et les doigts d\'un simplet ne feront pas l\'affaire. J\'ai besoin d\'un homme d\'une cruauté sans limite, et le seul que je vois en ce moment se balance par cette corde. Alors, qu\'en dites-vous ? Cinq cents couronnes, vous vous souvenez ?%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Très bien, je vais aller les chercher.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 30 || this.World.Assets.getMoney() <= 1000)
						{
							return "Good";
						}
						else
						{
							return "Bad";
						}
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Thief != null)
				{
					this.Options.push({
						Text = "Notre voleur, %thief%, semble avoir une idée.",
						function getResult( _event )
						{
							return "Thief";
						}

					});
				}

				if (_event.m.Minstrel != null)
				{
					this.Options.push({
						Text = "%minstrel% sourit d\'une oreille à l\'autre...",
						function getResult( _event )
						{
							return "Minstrel";
						}

					});
				}

				if (_event.m.Butcher != null)
				{
					this.Options.push({
						Text = "Il semblerait que %butcher% veuille vous donner un coup de main.",
						function getResult( _event )
						{
							return "Butcher";
						}

					});
				}

				this.Options.push({
					Text = "Nous ferions mieux de ne pas nous impliquer.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Good",
			Text = "[img]gfx/ui/events/event_43.png[/img]Vous vous frayez un chemin dans la foule, à la recherche de doigts, d\'orteils ou de poches ensanglantées. Un homme a quelque chose dans sa poche. Vous le poussez dans un coin et le secouez tout en ayant une dague sur sa gorge.\n\nPlus loin, vous voyez une femme au sourire maladif qui se déplace le long des pavés. C\'est une jeune fille méprisante si vous en avez jamais vu une. En la prenant à part, vous trouvez rapidement un doigt et un orteil dans le tissu de sa robe. Elle ment et dit que ce ne sont que des ingrédients de cuisine. Vous lui dites que si c\'est le cas, vous la dénoncerez aux gardes pour cannibalisme. Elle les abandonne.\n\nEn rendant les extrémités grossières au vieil homme, vous êtes rapidement payé les cinq cents couronnes. Il vous remercie à peine pour votre \"travail\" avant de s\'en aller. Il ne vous a jamais expliqué à quoi servaient exactement ces objets. Vous vous en fichez. Cinq cents couronnes, c\'est cinq cents couronnes.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Aussi facile que ça.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(500);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]500[/color] Couronnes"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "Bad",
			Text = "[img]gfx/ui/events/event_43.png[/img]Vous acceptez la tâche du vieil homme effrayant et commencez à traverser la foule, en gardant un œil attentif sur les orteils et les doigts qui se trouvent là où ils ne devraient pas être, ou sur les poches pleines de bosses fraîchement et rougement mouillées. Cela ne prend pas longtemps : une femme se pavane sur la route, le devant de sa robe bouillonnant assez curieusement de ce qu\'elle a dans la poche. Vous la tirez dans une ruelle, en sortant une dague pour la faire taire. Un doigt et un orteil sont trouvés. Alors que vous allez les prendre, un homme vous attaque soudainement par derrière. Les couronnes de votre sac à main et les appendices s\'envolent sur les pavés. Un enfant en prend une, un rat l\'autre, l\'endroit où l\'un ou l\'autre s\'enfuit est rapidement obscurci par une frénésie de paysans qui s\'en prennent à vos pièces. L\'homme qui vous a plaqué se prépare à frapper.%SPEECH_ON%Salaud, si tu la veux, tu dois payer !%SPEECH_OFF%Vous croisez les bras, bloquez le coup, et tordez votre corps pour le mettre au sol. Il est sur le point de dire autre chose, mais vous remplacez momentanément ses dents par vos poings et il se tait. Malheureusement, vous n\'avez pas pu finir ce que vous aviez commencé et vous avez perdu quelques pièces au passage.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Merde!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local money = this.Math.rand(200, 400);
				this.World.Assets.addMoney(-money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous perdez [color=" + this.Const.UI.Color.NegativeEventValue + "]" + money + "[/color] Couronnes"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "Thief",
			Text = "[img]gfx/ui/events/event_43.png[/img]%thief% rigole.%SPEECH_ON%Bon sang, ça va être facile.%SPEECH_OFF%Il s\'en va vers la foule et vous le perdez de vue en un instant. Le vieil homme se ronge les gencives pendant un moment avant d\'élever la voix.%SPEECH_ON%Ce type, il est digne de confiance ?%SPEECH_OFF%Avant que vous ne puissiez répondre, %thief% surgit de derrière l\'épaule du vieil homme et dépose un bandage sanglant dans ses paumes. L\'homme sinistre déballe les draps pour découvrir des extrémités fraîchement découpées. Le voleur sourit avec suffisance.%SPEECH_ON%Tout voleur digne de ce nom commence par être pickpocket avant toute autre chose. Je m\'attaque généralement aux clés plutôt qu\'aux orteils, mais un travail est un travail. J\'ai aussi récupéré d\'autres choses intéressantes ici et là. Jetez un coup d\'oeil.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bien joué.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Thief.getImagePath());
				this.World.Assets.addMoney(500);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]500[/color] Couronnes"
					}
				];
				local initiative = this.Math.rand(2, 4);
				_event.m.Thief.getBaseProperties().Initiative += initiative;
				_event.m.Thief.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Thief.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiative + "[/color] d\'Initiative"
				});
				_event.m.Thief.improveMood(1.0, "A utilisé ses talents uniques avec beaucoup de succès");

				if (_event.m.Thief.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Thief.getMoodState()],
						text = _event.m.Thief.getName() + this.Const.MoodStateEvent[_event.m.Thief.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Minstrel",
			Text = "[img]gfx/ui/events/event_92.png[/img]%minstrel% le ménestrel attrape le vieil homme par les épaules.%SPEECH_ON%Dis donc, quels muscles puissants vous semblez avoir, mon ami. Je ne vous demanderai pas pourquoi vous avez besoin des orteils et des doigts de cet homme mort...%SPEECH_OFF%Le vieil homme hoche la tête et dit qu\'il ne le dirait jamais de toute façon. Le ménestrel continue.%SPEECH_ON%...mais si vous voulez un homme bon, fort et violent, alors je ne le regarde pas déjà ? C\'est vous, mon vieux ! Prenez vos doigts et vos orteils et utilisez-les pour accomplir la tâche - ahem, quelle que soit la bizarrerie de cette tâche, ahem - et vous trouverez la récompense que vous cherchez. Vous êtes le héros de cette histoire, vous ne le voyez pas ?%SPEECH_OFF%Le vieil homme crache et secoue la tête.%SPEECH_ON%Vous me prenez pour un idiot, n\'est-ce pas ? Notre affaire ici est terminée ! Dégagez de mon chemin, mercenaires.%SPEECH_OFF%Le vieil homme s\'en va. Vous demandez au ménestrel ce qu\'il fait. Il hausse les épaules et vous tend une bourse de couronnes.%SPEECH_ON%Un tour de passe-passe.%SPEECH_OFF%Bien fait. Mais vous demandez où est votre propre sac. %minstrel% soulève un autre sac.%SPEECH_ON%Très, très bon tour de passe-passe.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Très drôle. Maintenant, rends-le-moi.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Minstrel.getImagePath());
				this.World.Assets.addMoney(500);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous perdez [color=" + this.Const.UI.Color.NegativeEventValue + "]500[/color] Couronnes"
				});
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]1000[/color] Couronnes"
				});
				local initiative = this.Math.rand(2, 4);
				_event.m.Minstrel.getBaseProperties().Initiative += initiative;
				_event.m.Minstrel.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Minstrel.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiative + "[/color] d\'Initiative"
				});
				_event.m.Minstrel.improveMood(1.0, "A utilisé ses talents uniques avec beaucoup de succès");

				if (_event.m.Minstrel.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Minstrel.getMoodState()],
						text = _event.m.Minstrel.getName() + this.Const.MoodStateEvent[_event.m.Minstrel.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Butcher",
			Text = "[img]gfx/ui/events/event_19.png[/img]%butcher% Le boucher crache et dit qu\'il va le faire. Vous lui dites qu\'il n\'est pas vraiment du genre à voler. Il secoue la tête.%SPEECH_ON%Non. Je veux dire que je vais lui donner un doigt. Juste un, mais ça sera un gros coup et ça vaudra son pesant d\'or en ce qui concerne ce vieux fou. En ce qui vous concerne, capitaine, je veux la moitié de la récompense.%SPEECH_OFF%L\'étranger effrayant acquiesce en souriant, sa peau sèche et écaillée se craquelle.%SPEECH_ON%Oui... oui ! Un homme qui ferait cela correspondrait certainement au profil des ingrédients dont j\'ai besoin. Faites-le. Faites-le !%SPEECH_OFF%Avant même que vous ayez pu accepter, le boucher s\'empare d\'une pince accrochée à un mur voisin, la place au sommet d\'une enclume, coince un doigt entre les pinces et appuie son genou sur la poignée, coupant ainsi un doigt d\'un seul coup. Il enveloppe sa main avant de céder l\'extrémité à l\'étranger.%SPEECH_ON%Voilà : le doigt d\'un homme particulièrement cruel.%SPEECH_OFF%L\'étranger la saisit comme si c\'était la clé du monde. \"Merveilleux !\'\', vous pensez qu\'il dit, mais c\'est difficile à entendre car il s\'empresse de vous donner quelques couronnes et de s\'enfuir. C\'est en fait plus que ce que vous aviez convenu au départ. Le boucher a certainement \"gagné\" sa moitié et vous la lui remettez.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Insensé.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Butcher.getImagePath());
				this.World.Assets.addMoney(300);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]300[/color] Couronnes"
				});
				_event.m.Butcher.improveMood(1.0, "A gagné une belle somme en vendant un de ses doigts.");

				if (_event.m.Butcher.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Butcher.getMoodState()],
						text = _event.m.Butcher.getName() + this.Const.MoodStateEvent[_event.m.Butcher.getMoodState()]
					});
				}

				local injury = _event.m.Butcher.addInjury([
					{
						ID = "injury.missing_finger",
						Threshold = 0.0,
						Script = "injury_permanent/missing_finger_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Butcher.getName() + " souffre de " + injury.getNameOnly()
				});
				_event.m.Butcher.getBaseProperties().Bravery += 3;
				_event.m.Butcher.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Butcher.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+3[/color] de Détermination"
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

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getSize() >= 2 && t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
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

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_thief = [];
		local candidates_minstrel = [];
		local candidates_butcher = [];
		local candidates_killer = [];

		foreach( b in brothers )
		{
			if (b.getBackground().getID() == "background.thief")
			{
				candidates_thief.push(b);
			}
			else if (b.getBackground().getID() == "background.minstrel")
			{
				candidates_minstrel.push(b);
			}
			else if (b.getBackground().getID() == "background.butcher" && !b.getSkills().hasSkill("injury.missing_finger"))
			{
				candidates_butcher.push(b);
			}
			else if (b.getBackground().getID() == "background.killer_on_the_run")
			{
				candidates_killer.push(b);
			}
		}

		if (candidates_thief.len() != 0)
		{
			this.m.Thief = candidates_thief[this.Math.rand(0, candidates_thief.len() - 1)];
		}

		if (candidates_minstrel.len() != 0)
		{
			this.m.Minstrel = candidates_minstrel[this.Math.rand(0, candidates_minstrel.len() - 1)];
		}

		if (candidates_butcher.len() != 0)
		{
			this.m.Butcher = candidates_butcher[this.Math.rand(0, candidates_butcher.len() - 1)];
		}

		if (candidates_killer.len() != 0)
		{
			this.m.Killer = candidates_killer[this.Math.rand(0, candidates_killer.len() - 1)];
		}

		this.m.Town = town;
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"thief",
			this.m.Thief != null ? this.m.Thief.getName() : ""
		]);
		_vars.push([
			"minstrel",
			this.m.Minstrel != null ? this.m.Minstrel.getName() : ""
		]);
		_vars.push([
			"butcher",
			this.m.Butcher != null ? this.m.Butcher.getName() : ""
		]);
		_vars.push([
			"killer",
			this.m.Killer != null ? this.m.Killer.getName() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Thief = null;
		this.m.Minstrel = null;
		this.m.Butcher = null;
		this.m.Killer = null;
		this.m.Town = null;
	}

});

