this.icy_cave_enter_event <- this.inherit("scripts/events/event", {
	m = {
		Champion = null
	},
	function create()
	{
		this.m.ID = "event.location.icy_cave_enter";
		this.m.Title = "En approchant...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A1",
			Text = "[img]gfx/ui/events/event_144.png[/img]{Vous découvrez une grotte dans la glace dont l\'entrée est protégée par une grille complètement givrée. En regardant à travers les barreaux de glace, vous constatez que la grotte descend rapidement en pente raide et se dirige vers ce qui pourrait être une rivière souterraine gelée depuis longtemps. Quelque chose est accroupi à côté d\'elle, frappant la glace avec une pioche, encore et encore. Le vent siffle en grinçant contre les parois de la grotte. Vous appelez l\'homme recroquevillé, mais il ne répond pas.\n\nIl faudra un certain temps pour couper la glace épaisse qui bloque l\'entrée. Heureusement, l\'un des mercenaires rapporte qu\'il y a peut-être une entrée à l\'arrière. Elle est également bloquée, mais un homme assez fort pourrait se faufiler à travers et faire face aux dangers à l\'intérieur.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Title = "En vous approchant...";
				local raw_roster = this.World.getPlayerRoster().getAll();
				local roster = [];

				foreach( bro in raw_roster )
				{
					if (bro.getPlaceInFormation() <= 17)
					{
						roster.push(bro);
					}
				}

				roster.sort(function ( _a, _b )
				{
					if (_a.getXP() > _b.getXP())
					{
						return -1;
					}
					else if (_a.getXP() < _b.getXP())
					{
						return 1;
					}

					return 0;
				});
				local e = this.Math.min(4, roster.len());

				for( local i = 0; i < e; i = ++i )
				{
					local bro = roster[i];
					this.Options.push({
						Text = "J\'ai besoin que vous y alliez en éclaireur, " + bro.getName() + ".",
						function getResult( _event )
						{
							_event.m.Champion = bro;
							return "B";
						}

					});
				}

				this.Options.push({
					Text = "Nous devrions quitter cet endroit.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "A2",
			Text = "[img]gfx/ui/events/event_144.png[/img]{Vous avez suivi les traces du mystérieux messager jusqu\'à une grotte dans la glace. Cette fois, elle n\'a pas été récemment visitée, car une épaisse barrière de glace maintient votre entrée bien gardée. Juste à côté de l\'entrée, se trouve un vieil homme, face contre terre dans la neige, aussi mort qu\'il peut l\'être, avec un bras tendu pointant vers la caverne.\n\n En regardant à travers les barrières gelées, vous constatez que la grotte descend rapidement en pente raide et se dirige vers ce qui pourrait être une rivière souterraine qui a gelée depuis longtemps. Quelque chose est accroupi de la rivière, frappant la glace avec une pioche encore et encore. Le vent siffle en ricochant contre les parois de la grotte. Vous appelez l\'homme recroquevillé, mais il n\'y a pas de réponse.\n\nIl faudra un certain temps pour découper cette glace épaisse et y arriver. Heureusement, un des mercenaires rapporte qu\'il y a peut-être une entrée à l\'arrière. Elle est bloquée, mais un homme assez fort pourrait se faufiler à travers et faire face aux dangers qui l\'attendent.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Title = "En vous approchant...";
				local roster = this.World.getPlayerRoster().getAll();
				roster.sort(function ( _a, _b )
				{
					if (_a.getXP() > _b.getXP())
					{
						return -1;
					}
					else if (_a.getXP() < _b.getXP())
					{
						return 1;
					}

					return 0;
				});
				local e = this.Math.min(4, roster.len());

				for( local i = 0; i < e; i = ++i )
				{
					local bro = roster[i];
					this.Options.push({
						Text = "J\'ai besoin que vous alliez en éclaireur, " + bro.getName() + ".",
						function getResult( _event )
						{
							_event.m.Champion = bro;
							return "B";
						}

					});
				}

				this.Options.push({
					Text = "Nous devrions quitter cet endroit.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_144.png[/img]{%chosen% part en éclaireur tandis que vous et les autres travaillez au niveau de l\'entrée de la grotte. Vous faites tomber quelques-uns des épais bloc de glace, ce qui vous permet de mieux voir dans la grotte. Au même moment, %chosen% tombe dans un trou et se retrouve à glisser sur une pente adjacente à la grotte, il atterrit en plein milieu de la caverne, glisse sur la rivière gelée puis parvient à rejoindre la berge. Il se lève d\'un bond et s\'époussette en souriant comme un enfant.\n\n En un éclair, l\'homme recroquevillé enfonce la pioche dans la glace avec une puissance inouïe et des éclats se répandent d\'un côté à l\'autre du talus. Le fracas du métal et de la glace brisée se répercute comme si la foudre avait frappé. Maintenant vous pouvez enfin voir l\'étranger: c\'est un barbare revêtu d\'une armure brisée qui résonne lorsqu\'il se déplace. Les murs glacés reflètent ses pas, dispersant sa présence tout autour de la grotte dans des reflets éphémères. Tremblante et saccadée, sa démarche semble revenir en arrière malgré son avancée, comme si son ombre était son vrai moi et sa chair l\'image rémanente. Bien qu\'il soit dans une grotte, sa voix puissante ne résonne pas du tout.%SPEECH_ON%Un intrus chez moi, une simple brume de passage, ces choses ne me manqueront pas.%SPEECH_OFF%Il s\'approche du mercenaire comme une araignée froide qui sort de sa cachette. Vous voyez que son visage est à moitié gelé, un sourire en coin se dessine sur la moitié qui pourrait encore être appelée \\'chair\\'.%SPEECH_ON%Il me tarde de quitter ce corps, mon cher guerrier. Me guiderez-vous vers quelque chose de plus grand?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.Music = this.Const.Music.BeastsTracks;
						properties.Entities = [];
						properties.Entities.push({
							ID = this.Const.EntityType.BarbarianMadman,
							Variant = 0,
							Row = 0,
							Script = "scripts/entity/tactical/humans/barbarian_madman",
							Faction = this.Const.Faction.Enemy
						});
						properties.Players.push(_event.m.Champion);
						properties.IsUsingSetPlayers = true;
						properties.IsFleeingProhibited = true;
						properties.IsAttackingLocation = true;
						properties.BeforeDeploymentCallback = function ()
						{
							local size = this.Tactical.getMapSize();

							for( local x = 0; x < size.X; x = ++x )
							{
								for( local y = 0; y < size.Y; y = ++y )
								{
									local tile = this.Tactical.getTileSquare(x, y);
									tile.Level = this.Math.min(1, tile.Level);
								}
							}
						};
						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(properties, false, false, false);
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "En vous approchant...";
				this.Options[0].Text = "Tu peux t\'en charger, %chosen%!";
				this.Characters.push(_event.m.Champion.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Text = "[img]gfx/ui/events/event_144.png[/img]{%chosen% découpe le fou. Son armure thoracique se brise et s\'envole de son corps, les morceaux de plaque tournent et s\'agitent dans l\'air, mais sont pourtant reliés entre eux par d\'étranges filaments bleus.\n\n Vos hommes percent enfin l\'entrée de la caverne glacée et glissent sur la pente. %chosen% se porte bien, hochant la tête avec suffisance en rengainant son arme.%SPEECH_ON%Juste un fou, capitaine.%SPEECH_OFF%Vous vous accroupissez à côté du corps. La glace déforme la moitié de la chair, la tordant en des nœuds noirs, et ce qui n\'est pas gelé est recouvert d\'une couche de calcaire étrangement scintillante. Malgré son état pitoyable, le fou est mort en affichant toujours un sourire de malade. Ses yeux sont d\'un bleu vif et vous vous voyez dans leur regard, une silhouette sans visage. Et puis la couleur s\'estompe lentement, pas comme vous l\'avez déjà vu, mais comme si quelqu\'un tirait un rideau devant une fenêtre, aspirant lentement toute la couleur jusqu\'au fond des orbites. Le cadavre vous sourit, mais vous refusez d\'y croire.\n\n L\'un des mercenaires ramasse l\'armure bizarre de l\'homme fou et la regarde longuement.%SPEECH_ON%Qu\'est-ce que vous pensez que cela peut être?%SPEECH_OFF%Les plaques sont suspendues les unes aux autres par une étrange gélatine bleue, l\'intérieur des lamelles métalliques est recouvert de bleus bouillonnants et virevoltants comme s\'il s\'agissait de l\'œuvre d\'un forgeron céleste. Il est froid au toucher et s\'ouvre sous la moindre pression du doigt. Vous n\'avez jamais vu ou senti quelque chose comme ça, mais l\'armure elle-même est actuellement dans un état inutilisable. Vous mettez la substance visqueuse et l\'armure dans l\'inventaire, fouillez la grotte pour plus de marchandises, mais il n\'y en a pas. Avant de quitter la grotte, vous jetez un dernier coup d\'oeil au cadavre. Vous pensez l\'avoir vu bouger à nouveau, mais c\'est sûrement le froid du nord qui vous joue des tours.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Vous avez bien fait, %chosen%.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "Après la bataille...";

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(true);
				}

				this.Characters.push(_event.m.Champion.getImagePath());
				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/special/broken_ritual_armor_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Defeat",
			Text = "[img]gfx/ui/events/event_144.png[/img]{À travers les barreaux glacés, vous peut voir le fou qui abat %chosen%. Même s\'il gît mort sur le sol, l\'étranger continue de le charcuter et, à chaque fois, un bruit sourd résonne dans la grotte. Que comptez-vous faire maintenant?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Title = "Après la bataille...";

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}

				local roster = this.World.getPlayerRoster().getAll();
				roster.sort(function ( _a, _b )
				{
					if (_a.getXP() > _b.getXP())
					{
						return -1;
					}
					else if (_a.getXP() < _b.getXP())
					{
						return 1;
					}

					return 0;
				});
				local e = this.Math.min(4, roster.len());

				for( local i = 0; i < e; i = ++i )
				{
					local bro = roster[i];
					this.Options.push({
						Text = "J\'ai besoin que vous y alliez, " + bro.getName() + ".",
						function getResult( _event )
						{
							_event.m.Champion = bro;
							return "B";
						}

					});
				}

				this.Options.push({
					Text = "Ça n\'en vaut pas la peine. Nous devrions quitter cet endroit.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_144.png[/img]{Au moment où vous quittez la grotte, un habitant du Nord couvert de fourrures d\'ours se tient en face de la compagnie. Il alterne son regard entre vous et l\'entrée de la grotte. Il demande.%SPEECH_ON%Parlez-vous la langue du sud ou seulement votre langue maternelle?%SPEECH_OFF%En restant sur vos gardes, vous confirmez la première. Il acquiesce.%SPEECH_ON%Et qu\'avez-vous vu dans cette grotte?%SPEECH_OFF%Vous lui dites que vous n\'avez rien trouvé à part un fou. L\'étranger sourit.%SPEECH_ON%Un fou. Un fou, c\'est ce que vous pensez avoir vu. Il est pas concevable pour nous de parler de ce qui n\'est pas naturel, mais il est aussi improbable de reconnaitre quand la nature prend elle-même du recul. Les horreurs sont plus faciles à dire qu\'à voir. Ce n\'était pas un homme ordinaire, idiot, mais l\'Ijirok, un esprit transitoire qui passe d\'un réceptacle à un autre. Personne ne sait vraiment à quoi il ressemble, le monde entier n\'est qu\'une série de masques pour lui, il passe allègrement de l\'un à l\'autre, prenant généralement la forme d\'animaux, parfois d\'un homme si il est faible. C\'est un être d\'une méchanceté sans limite. Il ne peut être tué, non, il considère la mort, même la sienne, comme un divertissement. Il se souvient de ceux qui lui ont échappé, il se souvient de ceux avec qui il veut jouer. Je prie pour que vous ayez un visage qui mérite d\'être oublié.%SPEECH_OFF%Vous posez votre main sur le pommeau de votre épée et vous lui dites que tout ce qui lui reste de mysticisme et de mythologie, il peut le garder pour lui. Vous avez vu le fou dans la grotte, et c\'était juste un homme. L\'étranger acquiesce à nouveau et s\'éloigne.%SPEECH_ON%Comme vous voulez, que vos voyages soient agréables.%SPEECH_OFF%} ",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bon voyage.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "Après la bataille...";
				this.World.Flags.set("IjirokStage", 4);
				local locations = this.World.EntityManager.getLocations();

				foreach( v in locations )
				{
					if (v.getTypeID() == "location.tundra_elk_location")
					{
						v.setVisibilityMult(0.8);
						v.onUpdate();
						break;
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"chosen",
			this.m.Champion != null ? this.m.Champion.getName() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		if (this.World.Flags.get("IjirokStage") == 3)
		{
			return "A2";
		}
		else
		{
			return "A1";
		}
	}

	function onClear()
	{
		this.m.Champion = null;
	}

});

