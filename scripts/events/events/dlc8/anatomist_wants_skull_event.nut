this.anatomist_wants_skull_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Thief = null,
		Wildman = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_wants_skull";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_16.png[/img]{Vous arrivez dans un village reculé et trouvez quelques-uns de ses habitants accroupis devant un grand crâne blanchi posé de façon décorative sur un lutrin. Les paysans qui passent s\'arrêtent et lui professent leur foi. En vous approchant, vous vous rendez compte que le crâne lui-même est exceptionnel: un long front et épais au sommet, il est assez dominant et strié. Sa mâchoire, encore intacte, possède des dents énormes et pointues, dont la plupart sont en désordre, ce type de dentition serait un danger en temps normal. Ce qu\'il pourrait bien être, c\'est le crâne d\'un Nachzehrer. Naturellement, avec cette étrange image squelettique qui vous fait face, vous espérez détourner la compagnie avant-%SPEECH_ON%Nous devrions l\'étudier.%SPEECH_OFF%En soupirant, vous vous retournez pour voir %anatomist% debout, en train de reluquer le crâne. Vous le corrigez en lui disant que ce qu\'il veut vraiment, c\'est de le voler. L\'anatomiste vous fixe.%SPEECH_ON%Le vocabulaire n\'a pas d\'importance, car une fois l\'étude terminée, il sera plus utile dans nos mains que dans les leurs, c\'est clair.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "D\'accord, prenez-le.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "Je ne pense pas.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Thief != null)
				{
					this.Options.push({
						Text = "Qu\'est-ce que notre voleur %thief% a à dire ?",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.Wildman != null)
				{
					this.Options.push({
						Text = "Ce crâne ressemble à notre homme sauvage, %wildman%.",
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
			Text = "[img]gfx/ui/events/event_46.png[/img]{En soupirant, vous acceptez les fantaisies de l\'anatomiste, mais vous lui dites que c\'est à lui de le voler si vous voulez qu\'il l\'étudie. L\'homme n\'hésite même pas et s\'en va, les yeux rivés sur la pièce osseuse représentant son délire scientifique. Vous ne serez pas responsable du chaos qui se produira s\'il se fait prendre, alors vous le laissez faire, vous retournez faire l\'inventaire tout en gardant les oreilles ouvertes pour entendre les bruits du chaos religieux.Quelques instants plus tard, %anatomist% revient, un gros crâne bercé sous son bras, quelques gouttelettes de sueurs sont présentes sur son front.%SPEECH_ON%C\'est le crâne d\'un Nachzehrer et il devrait être d\'une grande valeur pour nos études.%SPEECH_OFF%Curieux, vous lui demandez comment il a réussi à obtenir le crâne en premier lieu. %anatomiste% lève un sourcil.%SPEECH_ON%Vous ne regardiez pas? J\'ai trouvé la tentative assez impressionnante, mais hélas si impressionnante soit-elle, elle n\'hésitera pas à vous faire douter de sa véracité. Une fable, si vous voulez. Sachez juste que nous devrions probablement partir d\'ici bientôt. Peut-être plus tôt que prévue et le plus rapidement possible. Est-ce que vous comprenez?%SPEECH_OFF%Un brouhaha de cris se fait entendre au loin. L\'anatomiste s\'essuie le front, se retourne et s\'éloigne. L\'arrière de sa chemise est déchiré par des griffes et de petites fléchettes ou flèches sortent de son dos - et ces cris lointains sont de plus en plus forts.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Hmm.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(1.0, "Acquired an unusual skull to study");
				_event.m.Anatomist.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Anatomist.getName() + " suffers light wounds"
				});
				local resolveBoost = this.Math.rand(1, 3);
				local initiativeBoost = this.Math.rand(1, 3);
				_event.m.Anatomist.getBaseProperties().Bravery += resolveBoost;
				_event.m.Anatomist.getBaseProperties().Initiative += initiativeBoost;
				_event.m.Anatomist.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Anatomist.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolveBoost + "[/color] Resolve"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Anatomist.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiativeBoost + "[/color] Initiative"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Vous dites à %anatomist% qu\'il peut prendre le crâne. Il vous regarde fixement pendant un moment, puis dit qu\'il pensait que c\'était vous qui alliez le faire. Vous lui dites qu\'il est hors de question que vous preniez un crâne à des paysans locaux qui vénèrent ledit crâne. S\'il veut étudier, alors c\'est lui qui doit voler. %anatomist% porte une main à sa poitrine.%SPEECH_ON%Je suis un homme de science, et pas un scribe ordinaire, je ne pourrais pas m\'atteler à une tâche d\'une telle bassesse. Il faut un homme de savoir faire, un homme qui comprend le grain et la crasse de la vie quotidienne pour voler ce crâne.%SPEECH_OFF%L\'anatomiste serre le poing, si certain que son discours n\'est pas une insulte pour vous que ses yeux fixent le ciel avec une férocité certaine.%SPEECH_ON%De quoi parlez-vous, étrangers?%SPEECH_OFF%Vous vous retournez tous les deux pour voir un paysan tenant une fourche, et comme quelques autres le rejoignent, il fait signe vers vous.%SPEECH_ON%Ces types voulaient voler le crâne!%SPEECH_OFF%Vous tendez les mains, expliquant que... avant que vous n\'ayez fini, %anatomist% se retourne et part en courant. Réfléchissant vite, vous le traitez de voleur et promettez d\'avoir sa tête, faisant un show ridicule en sortant votre épée et en l\'agitant vers les paysans. Vous faites semblant de laisser tomber accidentellement une bourse de couronnes, transformant la colère des paysans en avidité, vous donnant suffisamment de temps pour vous échapper.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Partons d\'ici.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-100);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]100[/color] Crowns"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_65.png[/img]{En soupirant, vous acceptez l\'idée de voler le crâne. Avant que vous ne puissiez en dire plus, %thief% le voleur apparaît. Il s\'avance en mâchant de l\'herbe et en marchant avec assurance.%SPEECH_ON%Alors vous voulez voler quelque chose, hm? Pointez juste ce dont vous avez besoin et je vais aller le chercher pour vous. De l\'or? Une arme?%SPEECH_OFF%%anatomist% montre le crâne. Le voleur le fixe un moment avant de se retourner.%SPEECH_ON%Oh, euh, d\'accord.%SPEECH_OFF%Le voleur et futur voleur de crâne s\'éloigne. Vous allez faire l\'inventaire, lui laissant le temps de faire son travail. Il revient ensuite avec le crâne, ainsi qu\'avec une série d\'armes et d\'armures. Alors que vous fixez les marchandises manifestement volées, l\'homme hausse les épaules.%SPEECH_ON%Quoi? Je devais faire en sorte que ça vaille le coup.%SPEECH_OFF%L\'anatomiste emporte le crâne sans dire un mot, en fixant ses orbites vides comme s\'il s\'agissait d\'un amant et en murmurant que son regard vide lui apprendra beaucoup de choses. Le voleur fait de même, mais à la place avec une sacoche de couronnes et autres goodies, lui-même marmonnant qu\'il va enfin pouvoir se payer deux putes en même temps, un rêve qu\'il semble avoir depuis longtemps. Vous prenez les armes et les armures et les mettez dans l\'inventaire. Au loin vous entendez les gémissements des paysans qui cherchent la relique.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Une victoire est une victoire.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(1.0, "Acquired an unusual skull to study");
				_event.m.Thief.improveMood(1.0, "Successfully stole from the peasantry");

				if (_event.m.Anatomist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				if (_event.m.Thief.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Thief.getMoodState()],
						text = _event.m.Thief.getName() + this.Const.MoodStateEvent[_event.m.Thief.getMoodState()]
					});
				}

				_event.m.Anatomist.addXP(100, false);
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Anatomist.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+100[/color] Experience"
				});
				local initiativeBoost = this.Math.rand(2, 4);
				_event.m.Thief.getBaseProperties().Initiative += initiativeBoost;
				_event.m.Thief.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Thief.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiativeBoost + "[/color] Initiative"
				});
				local item;
				local weaponList = [
					"militia_spear",
					"militia_spear",
					"militia_spear",
					"shortsword",
					"falchion",
					"light_crossbow"
				];
				local itemAmount = this.Math.rand(1, 2);

				for( local i = 0; i < itemAmount; i = ++i )
				{
					item = this.new("scripts/items/weapons/" + weaponList[this.Math.rand(0, weaponList.len() - 1)]);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "You gain " + item.getName()
					});
					this.World.Assets.getStash().add(item);
				}

				local armorList = [
					"leather_tunic",
					"leather_tunic",
					"thick_tunic",
					"thick_tunic",
					"padded_surcoat",
					"padded_leather"
				];
				itemAmount = this.Math.rand(1, 2);

				for( local i = 0; i < itemAmount; i = ++i )
				{
					item = this.new("scripts/items/armor/" + armorList[this.Math.rand(0, armorList.len() - 1)]);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "You gain " + item.getName()
					});
					this.World.Assets.getStash().add(item);
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Thief.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Vous décidez que si les anatomistes peuvent faire un grand usage du crâne, alors vous accepterez de leur donner la chance de l\'étudier. La question est de savoir comment s\'y prendre pour voler un crâne hideux à un groupe si fou pour le vénérer? Comme si c\'était le moment, %wildman% le sauvage apparaît, dévorant une poignée de vers. Son visage rincé par la nature et son crâne cruellement formé semblent presque apparentés à la monstruosité qui trône sur le pupitre du centre du village. %anatomist% claque des doigts et prétend avoir une idée. Il tire le sauvage en avant, les deux marchent droit vers le crâne bien-aimé des villageois.\n\nL\'anatomiste pousse l\'homme sauvage devant les priants et prétend qu\'ils ont assassiné son cousin. Il déclare qu\'en ayant fait ceci, ils l\'ont condamné à une vie de malédiction. La foule est horrifiée, ne réalisant pas l\'erreur qu\'elle a commise. Le sauvage mange un autre ver. Vous continuez à regarder l\'anatomiste ramasser le crâne, le soulever au-dessus de sa tête et dire qu\'avec cela, il pourra enfin guérir %wildman% de ses maux et, à travers lui, lever toutes les malédictions qui se sont abattues sur le village. À ce stade, la foule s\'est levée, s\'est rapprochée de l\'anatomiste comme d\'un prêtre de haut rang, elle l\'applaudit lorsqu\'il part, acclamant pour ainsi dire le vol, le crâne au-dessus de sa tête. Les deux hommes reviennent vers vous. L\'anatomiste sourit.%SPEECH_ON%Pour étudier le corps, il ne faut pas oublier d\'étudier l\'esprit, et en étudiant l\'esprit, il ne faut pas oublier d\'étudier les esprits, au pluriel! Car plusieurs esprits mis ensemble sont une créature à étudier en soi.%SPEECH_OFF%L\'anatomiste s\'en va. Un groupe de paysans s\'approche, portant des marchandises de toutes sortes. Ils les jettent aux pieds de %wildman% en guise d\'excuses. Le sauvageon mange un autre ver.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Hmm, d\'accord.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(1.0, "Acquired an unusual skull to study");
				_event.m.Wildman.improveMood(1.0, "Helped " + _event.m.Anatomist.getName() + " acquire an unusual skull");

				if (_event.m.Anatomist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				if (_event.m.Wildman.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Wildman.getMoodState()],
						text = _event.m.Wildman.getName() + this.Const.MoodStateEvent[_event.m.Wildman.getMoodState()]
					});
				}

				local initiativeBoost = this.Math.rand(1, 3);
				_event.m.Anatomist.getBaseProperties().Initiative += initiativeBoost;
				_event.m.Anatomist.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Anatomist.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiativeBoost + "[/color] Initiative"
				});
				_event.m.Wildman.addXP(75, false);
				_event.m.Wildman.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Wildman.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+75[/color] Experience"
				});
				local food;
				local r = this.Math.rand(1, 3);

				if (r == 1)
				{
					food = this.new("scripts/items/supplies/cured_venison_item");
				}
				else if (r == 2)
				{
					food = this.new("scripts/items/supplies/pickled_mushrooms_item");
				}
				else if (r == 3)
				{
					food = this.new("scripts/items/supplies/roots_and_berries_item");
				}

				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "You gain " + food.getName()
				});
				local goods;
				r = this.Math.rand(1, 2);

				if (r == 1)
				{
					goods = this.new("scripts/items/trade/cloth_rolls_item");
				}
				else if (r == 2)
				{
					goods = this.new("scripts/items/trade/peat_bricks_item");
				}

				this.World.Assets.getStash().add(goods);
				this.List.push({
					id = 10,
					icon = "ui/items/" + goods.getIcon(),
					text = "You gain " + goods.getName()
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Wildman.getImagePath());
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

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomist_candidates = [];
		local thief_candidates = [];
		local wildman_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.thief")
			{
				thief_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.wildman")
			{
				wildman_candidates.push(bro);
			}
		}

		if (thief_candidates.len() > 0)
		{
			this.m.Thief = thief_candidates[this.Math.rand(0, thief_candidates.len() - 1)];
		}

		if (wildman_candidates.len() > 0)
		{
			this.m.Wildman = wildman_candidates[this.Math.rand(0, wildman_candidates.len() - 1)];
		}

		if (anatomist_candidates.len() > 0)
		{
			this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		}
		else
		{
			return;
		}

		this.m.Score = 5 + anatomist_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getName()
		]);
		_vars.push([
			"thief",
			this.m.Thief != null ? this.m.Thief.getNameOnly() : ""
		]);
		_vars.push([
			"wildman",
			this.m.Wildman != null ? this.m.Wildman.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Thief = null;
		this.m.Wildman = null;
	}

});

