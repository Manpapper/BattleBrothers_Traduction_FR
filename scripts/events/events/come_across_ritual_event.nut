this.come_across_ritual_event <- this.inherit("scripts/events/event", {
	m = {
		Cultist = null
	},
	function create()
	{
		this.m.ID = "event.come_across_ritual";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]Il n\'est pas rare de trouver un cadavre sur votre chemin. Celui-ci, cependant, est plutôt inhabituel. %randombrother% regarde longuement.%SPEECH_ON%Qu\'est-ce qu\'il a sur son torse ?%SPEECH_OFF%Vous vous accroupissez et jetez en arrière la chemise du cadavre. Des cicatrices parcourent son corps dans le sens de la longueur, dessinant des formes très familières : forêts, rivières, montagnes. %randombrother% s\'approche.%SPEECH_ON%N\'est-ce pas un spectacle. Est-ce que des loups feraient ça ou quelque chose comme ça ?%SPEECH_OFF%Vous vous relevez.%SPEECH_ON%Je pense qu\'il s\'est fait ça lui-même.%SPEECH_OFF%Des empreintes de sang s\'éloignent de la scène...",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Suivons ces empreintes",
					function getResult( _event )
					{
						return "Arrival";
					}

				},
				{
					Text = "Cela ne nous concerne pas.",
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
			ID = "Arrival",
			Text = "[img]gfx/ui/events/event_140.png[/img]En suivant les pas, vous commencez à entendre les murmures d\'un chant. Vous dites à la compagnie de se reposer pendant que vous vous faufilez vers l\'avant, trouvant finalement un grand feu de camp autour duquel tournent des hommes en cape. Ils tapent des pieds et lèvent les mains en l\'air, en criant quelques mots symboliques à leur ancien dieu, Davkul. C\'est une cérémonie bestiale, les rugissements et les grognements abondent, et ces hommes dansent avec des vêtements trop grands comme des esprits sombres encore en colère contre le monde qu\'ils ont quitté. %randombrother% se glisse à côté de vous et secoue la tête.%SPEECH_ON%Qu\'est-ce qui se passe là-bas ? Que faisons-nous ?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous devons arrêter ça maintenant. A l\'attaque !",
					function getResult( _event )
					{
						return "Attack1";
					}

				},
				{
					Text = "Attendons et voyons ce qui se passe.",
					function getResult( _event )
					{
						return "Observe1";
					}

				},
				{
					Text = "Il est temps de partir. Maintenant.",
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
			ID = "Observe1",
			Text = "[img]gfx/ui/events/event_140.png[/img]Vous décidez d\'attendre et de voir ce qui se passe. Au moment où vous dites cela, les cultistes traînent un vieil homme devant le feu. Il baisse la tête devant les flammes, ouvre les bras, puis tombe dedans. Il n\'y a pas de cris. Un autre homme est tiré en avant. Il murmure des mots à un cultistes, ils acquiescent tous les deux, et lui aussi s\'immole par les flammes. Un troisième est poussé vers l\'avant, mais contrairement aux autres, il est enchaîné et a le regard sauvage. Il hurle aux cultistes.%SPEECH_ON% Saleté de dieu, il ne veut rien dire ! Ce n\'est qu\'un mensonge !%SPEECH_OFF%Un visage apparaît dans les flammes, sa forme gonflée et agitée par la fumée et le feu. C\'est la cruauté incarnée, et il ne pourrait être mieux peint par les flammes que par l\'obscurité elle-même. Il se tourne et sourit. L\'un des cultistes crie.%SPEECH_ON%Davkul t\'attends!%SPEECH_OFF%Mais le prisonnier donne un coup de pied à l\'un de ses ravisseurs et tente de s\'enfuir.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "J\'en ai vu assez. Nous devons l\'aider, maintenant !",
					function getResult( _event )
					{
						return "Attack2";
					}

				},
				{
					Text = "Attendez, voyons ce qui se passe ensuite.",
					function getResult( _event )
					{
						return "Observe2";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Cultist != null)
				{
					this.Options.push({
						Text = "%cultist%, n\'est-ce pas ton culte ?",
						function getResult( _event )
						{
							return "Cultist";
						}

					});
				}

				this.Options.push({
					Text = "Il est temps de partir. Maintenant.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Observe2",
			Text = "[img]gfx/ui/events/event_140.png[/img]Vous décidez d\'attendre et de voir ce qui se passe. Le visage de feu revient, une grande gueule magmatique s\'ouvre alors que l\'homme enchaîné est poussé en avant. Il crie et se penche en arrière, mais c\'est inutile. Ses vêtements brûlent et les lambeaux s\'envolent vers l\'arrière en lambeaux orange. Sa peau pèle comme si ce n\'était pas le feu, mais un millier de scalpels qui traversaient son corps. Par un feu blanc aiguisé, il est écorché. Son crâne est percé, frétillant et tremblant comme un serpent qui se débarrasse de sa peau, et ses yeux restent, bien que le reste de son corps soit dépouillé de sa chair, de ses organes et de ses os. Quand il n\'est plus qu\'un crâne avec des yeux, le visage dans le feu ferme la bouche et les grands hurlements du sacrifice se taisent. Le feu de joie s\'éteint en un instant et l\'homme, ou ce qu\'il en reste, tombe sur la terre. Les yeux brillent et s\'éteignent lentement comme un fer chaud qui refroidit.\n\nUn des cultistes se penche et ramasse le crâne. Il le fend facilement en deux, laissant tomber le cerveau tout en tenant ce qui était un visage. Alors qu\'il tient les restes vers l\'extérieur, les os noircissent et s\'inversent, créant un visage cruel d\'une obscurité totale entouré d\'une bordure d\'os. Il l\'enfile et commence à partir.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous attaquons, maintenant !",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.CivilianTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];

						for( local i = 0; i < 25; i = ++i )
						{
							local unit = clone this.Const.World.Spawn.Troops.Cultist;
							unit.Faction <- this.Const.Faction.Enemy;
							properties.Entities.push(unit);
						}

						properties.Loot = [
							"scripts/items/helmets/legendary/mask_of_davkul"
						];
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				},
				{
					Text = "Nous partons aussi.",
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
			ID = "Cultist",
			Text = "[img]gfx/ui/events/event_140.png[/img]Vous demandez à %cultist% s\'il peut faire quelque chose. Il passe simplement devant vous et descend la colline. Le groupe de cultistes se tourne vers lui et le regarde. Il traverse la foule jusqu\'au prisonnier. Ils parlent. Il chuchote, le prisonnier acquiesce. Quand ils ont terminé, %cultist% fait un signe de tête aux cultistes. Un membre s\'avance, se déshabille et se jette dans le feu, sans crier et sans protester. Un autre cultiste pique les flammes avec un rateau, en arrache quelque chose et le remet à %cultist%. Le prisonnier, dont la vie a apparemment été épargnée lors de l\'échange, est libéré et vous regardez %cultist% l\'attraper et le ramener sur la colline. Il pousse l\'homme en avant tout en parlant.%SPEECH_ON%Vous avez pris à Davkul, mais la dette est payée.%SPEECH_OFF%Vous demandez ce qu\'il a dans sa main. Le cultistes montre ce qui a été récupéré dans les flammes. Il s\'agit d\'un crâne rapiécé avec de la chair coriace, et sur son visage est tendu un visage fraîchement brûlé, probablement celui de l\'homme qui s\'est jeté dans le feu. De légers indices de son visage se tordent et tournent, sa bouche est entrouverte, déformée par une obscurité cruelle et murmurante. %cultist% parle sans hésiter, en le tenant toujours en l\'air comme un indigène montrant son précieux scalp.%SPEECH_ON%Davkul nous attends tous.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Qu\'est-ce que c\'est",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/helmets/legendary/mask_of_davkul");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Attack1",
			Text = "[img]gfx/ui/events/event_140.png[/img]Vous donnez l\'ordre d\'attaquer. Vos hommes s\'arment et se précipitent en avant. Le feu meurt en un instant, se transformant en cendres qui s\'échappent en un grand nuage. Une fois le feu éteint, la foule sinistre ouvre les bras et parle à l\'unisson.%SPEECH_ON%Davkul attend. Venez le saluer.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Aux armes!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.CivilianTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];

						for( local i = 0; i < 25; i = ++i )
						{
							local unit = clone this.Const.World.Spawn.Troops.Cultist;
							unit.Faction <- this.Const.Faction.Enemy;
							properties.Entities.push(unit);
						}

						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Attack2",
			Text = "[img]gfx/ui/events/event_140.png[/img]Vous ne supportez pas cette injustice et décidez de charger et de sauver l\'homme. Alors que vous vous tenez debout et levez votre épée pour donner l\'ordre, le feu de joie fait surgir un grand tentacule magmatique qui attrape l\'homme enchaîné et le tire dans les flammes. Il n\'y a que le plus bref des cris et ensuite il est parti. Le feu se condense en un pilier qui s\'effondre rapidement. Un panache de cendres explose à l\'extérieur. L\'homme a disparu et c\'est comme s\'il n\'y avait pas eu de feu du tout. Il n\'y a même pas de fumée dans le ciel.\n\n Les cultistes se tournent vers vous, pointent du doigt et parlent à l\'unisson.%SPEECH_ON%Apportez la mort, la vôtre ou la nôtre, car Davkul nous attend tous.%SPEECH_OFF%Vous faiblissez un moment, puis vous donnez l\'ordre de charger.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Aux armes!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.CivilianTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];

						for( local i = 0; i < 25; i = ++i )
						{
							local unit = clone this.Const.World.Spawn.Troops.Cultist;
							unit.Faction <- this.Const.Faction.Enemy;
							properties.Entities.push(unit);
						}

						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getTime().Days <= 200)
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;

		foreach( t in towns )
		{
			local d = playerTile.getDistanceTo(t.getTile());

			if (d >= 4 && d <= 10)
			{
				nearTown = true;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 11 && (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 2)
		{
			return;
		}

		if (candidates.len() != 0)
		{
			this.m.Cultist = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		this.m.Score = 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cultist",
			this.m.Cultist != null ? this.m.Cultist.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Cultist = null;
	}

});

